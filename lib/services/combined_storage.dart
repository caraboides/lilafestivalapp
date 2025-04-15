import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../utils/logging.dart';
import 'app_storage.dart';
import 'festival_hub.dart';

class CombinedStorage {
  const CombinedStorage();

  AppStorage get _appStorage => dimeGet<AppStorage>();
  FestivalHub get _festivalHub => dimeGet<FestivalHub>();
  Logger get _log => const Logger(module: 'COMBINED_STORAGE');

  Future<Optional<T>> _loadDataFromAssets<T, J>(
    BuildContext context,
    String assetPath,
    T Function(J) fromJson,
  ) {
    _log.debug('Reading asset data from $assetPath');
    return DefaultAssetBundle.of(context)
        .loadString(assetPath)
        .then((content) {
          final json = jsonDecode(content);
          final data = fromJson(json);
          _log.debug('Reading asset data from $assetPath was successful');
          return Optional.of(data);
        })
        .catchError((error) {
          _log.error('Error reading asset data from $assetPath', error);
          return Optional<T>.empty();
        });
  }

  Future<Optional<T>> _loadDataFromAppStorage<T, J>(
    String appStorageKey,
    T Function(J) fromJson,
  ) async {
    _log.debug('Reading app storage data from $appStorageKey');
    final result = await _appStorage.loadJson<J>(appStorageKey);
    return result
        .map((json) {
          try {
            final data = fromJson(json);
            _log.debug(
              'Reading app storage data from $appStorageKey was '
              'successful',
            );
            return Optional.of(data);
          } catch (error) {
            _log.error(
              'Error reading app storage data from $appStorageKey',
              error,
            );
            return Optional<T>.empty();
          }
        })
        .orElseGet(() {
          _log.debug('Reading app storage data from $appStorageKey failed');
          return Optional<T>.empty();
        });
  }

  Future<Optional<T>> _loadOfflineData<T, J>({
    required BuildContext context,
    required String appStorageKey,
    required String assetPath,
    required T Function(J) fromJson,
  }) => _loadDataFromAppStorage(appStorageKey, fromJson).then(
    (result) => result
        .map((data) => Optional.of(data))
        .orElseGetAsync(
          () => _loadDataFromAssets(context, assetPath, fromJson),
        ),
  );

  Future<void> _sendErrorToStream(
    StreamController streamController,
    String key,
  ) {
    if (!streamController.isClosed) {
      streamController.addError(
        Exception('Loading both remote and offline data failed for $key'),
      );
    }
    return streamController.close();
  }

  StreamController<T> loadData<T, J>({
    required BuildContext context,
    required String remoteUrl,
    required String appStorageKey,
    required String assetPath,
    required T Function(J) fromJson,
    Duration? periodicDuration,
  }) {
    final streamController = StreamController<T>();
    var loadingRemoteDataFailed = false;
    var loadingOfflineDataFailed = false;
    var loadingOfflineDataFinished = false;
    var loadingRemoteDataFinished = false;
    final periodic = periodicDuration != null;
    if (periodic) {
      Timer? periodicTimer;
      void loadRemoteUpdates() {
        if (periodicTimer?.isActive ?? false) {
          return;
        }
        _log.debug('Setup timer for updating remote data');
        periodicTimer = Timer.periodic(periodicDuration, (timer) {
          _log.debug('Try to update remove data');
          _festivalHub
              .loadJsonData<J>(remoteUrl)
              .then(
                (result) => result.ifPresent((json) {
                  try {
                    final data = fromJson(json);
                    _log.debug(
                      'Updating remote data from $remoteUrl was successful',
                    );
                    if (!streamController.isClosed) {
                      streamController.add(data);
                    }
                    _appStorage.storeJson(appStorageKey, json);
                  } catch (error) {
                    _log.error(
                      'Error updating remote data from $remoteUrl',
                      error,
                    );
                  }
                }),
              );
        });
      }

      streamController.onCancel = () => periodicTimer?.cancel();
      streamController.onPause = () => periodicTimer?.cancel();
      streamController.onResume = () => loadRemoteUpdates();
      loadRemoteUpdates();
    }
    _log.debug('Loading remote data from $remoteUrl');
    _festivalHub
        .loadJsonData<J>(remoteUrl)
        .then(
          (result) => result.ifPresent(
            (json) async {
              try {
                final data = fromJson(json);
                _log.debug(
                  'Loading remote data from $remoteUrl was successful, '
                  "${periodic ? 'waiting for updates' : 'closing stream'}",
                );
                if (!streamController.isClosed) {
                  streamController.add(data);
                  loadingRemoteDataFinished = true;
                }
                if (!periodic) {
                  await streamController.close();
                }
                await _appStorage.storeJson(appStorageKey, json);
              } catch (error) {
                _log.error('Error loading remote data from $remoteUrl', error);
                loadingRemoteDataFailed = true;
                if (loadingOfflineDataFailed) {
                  await _sendErrorToStream(streamController, appStorageKey);
                } else if (loadingOfflineDataFinished && !periodic) {
                  await streamController.close();
                }
              }
            },
            orElse: () {
              _log.debug(
                'Loading remote data from $remoteUrl failed, '
                'rely on offline data',
              );
              loadingRemoteDataFailed = true;
              if (loadingOfflineDataFailed) {
                _sendErrorToStream(streamController, appStorageKey);
              } else if (loadingOfflineDataFinished && !periodic) {
                streamController.close();
              }
            },
          ),
        );

    _log.debug('Loading offline data for $appStorageKey');
    _loadOfflineData(
      context: context,
      appStorageKey: appStorageKey,
      assetPath: assetPath,
      fromJson: fromJson,
    ).then(
      (result) => result.ifPresent(
        (data) async {
          _log.debug('Loading offline data was successful for $appStorageKey');
          if (!streamController.isClosed && !loadingRemoteDataFinished) {
            streamController.add(data);
            loadingOfflineDataFinished = true;
            if (loadingRemoteDataFailed && !periodic) {
              await streamController.close();
            }
          }
        },
        orElse: () async {
          _log.debug('Loading offline data failed for $appStorageKey');
          loadingOfflineDataFailed = true;
          if (loadingRemoteDataFailed) {
            await _sendErrorToStream(streamController, appStorageKey);
          }
        },
      ),
    );

    return streamController;
  }
}
