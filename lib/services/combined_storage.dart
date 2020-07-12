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
  Logger get _log => const Logger('COMBINED_STORAGE');

  Future<Optional<T>> _loadDataFromAssets<T, J>(
    BuildContext context,
    String assetPath,
    T Function(J) fromJson,
  ) {
    _log.debug('Reading asset data from $assetPath');
    return DefaultAssetBundle.of(context).loadString(assetPath).then((content) {
      final json = jsonDecode(content);
      final data = fromJson(json);
      _log.debug('Reading asset data from $assetPath was successful');
      return Optional.of(data);
    }).catchError((error) {
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
    return result.map((json) {
      try {
        final data = fromJson(json);
        _log.debug('Reading app storage data from $appStorageKey was '
            'successful');
        return Optional.of(data);
      } catch (error) {
        _log.error('Error reading app storage data from $appStorageKey', error);
        return Optional<T>.empty();
      }
    }).orElseGet(() {
      _log.debug('Reading app storage data from $appStorageKey failed');
      return Optional<T>.empty();
    });
  }

  Future<Optional<T>> _loadOfflineData<T, J>({
    BuildContext context,
    String appStorageKey,
    String assetPath,
    T Function(J) fromJson,
  }) =>
      _loadDataFromAppStorage(appStorageKey, fromJson).then(
        (result) => result.map((data) => Optional.of(data)).orElseGetAsync(
            () => _loadDataFromAssets(context, assetPath, fromJson)),
      );

  // TODO(SF) STYLE replace null checks everywhere with optionals?
  // TODO(SF) STYLE improve?
  StreamController<T> loadData<T, J>({
    BuildContext context,
    String remoteUrl,
    String appStorageKey,
    String assetPath,
    T Function(J) fromJson,
  }) {
    final streamController = StreamController<T>();
    _log.debug('Loading remote data from $remoteUrl');
    _festivalHub.loadJsonData<J>(remoteUrl).then(
          (result) => result.ifPresent((json) {
            try {
              // TODO(SF) ERROR HANDLING
              final data = fromJson(json);
              _log.debug('Loading remote data from $remoteUrl was successful, '
                  'closing stream');
              // TODO(SF) STATE what if already closed?
              streamController.add(data);
              streamController.close();
              _appStorage.storeJson(appStorageKey, json);
            } catch (error) {
              _log.error('Error loading remote data from $remoteUrl', error);
              // TODO(SF) STATE close stream if fallback data was loaded already
            }
          }, orElse: () {
            _log.debug('Loading remote data from $remoteUrl failed, '
                'rely on offline data');
            // TODO(SF) STATE close stream if fallback data was loaded already
          }),
        );

    _log.debug('Loading offline data');
    _loadOfflineData(
      context: context,
      appStorageKey: appStorageKey,
      assetPath: assetPath,
      fromJson: fromJson,
    ).then(
      (result) => result.ifPresent((data) {
        _log.debug('Loading offline data was successful');
        if (!streamController.isClosed) {
          streamController.add(data);
          // TODO(SF) STATE close stream if loading remote data failed
        }
      }, orElse: () {
        _log.debug('Loading offline data failed');
        // TODO(SF) STATE send error to stream if loading failed completely
        // TODO(SF) STATE close stream if loading remote data failed
      }),
    );

    return streamController;
  }
}
