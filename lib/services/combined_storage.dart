import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../models/festival_config.dart';
import 'app_storage.dart';
import 'festival_hub.dart';

class CombinedStorage {
  AppStorage get _appStorage => dimeGet<AppStorage>();
  FestivalHub get _festivalHub => dimeGet<FestivalHub>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  Future<Optional<J>> _loadJsonDataFromAssets<J>(
    BuildContext context,
    String assetKey,
  ) =>
      DefaultAssetBundle.of(context)
          .loadString(_config.assetRootPath + assetKey)
          .then((json) =>
              Optional.ofNullable(json != null ? jsonDecode(json) : null))
          .catchError((e) {
        print(e);
        return Optional<J>.empty();
      });

  Future<Optional<J>> _loadJsonDataFromAppStorage<J>(
    String appStorageKey,
  ) =>
      _appStorage.loadJson<J>(appStorageKey);

  Future<Optional<J>> _loadRemoteJsonData<J>(
    String remoteUrl,
  ) =>
      _festivalHub.loadJsonData<J>(remoteUrl).catchError(print);

  Future<Optional<J>> _loadOfflineJsonData<J>({
    BuildContext context,
    String appStorageKey,
    Optional<String> assetKey,
  }) =>
      _loadJsonDataFromAppStorage(appStorageKey)
          .then((result) => result
              .map((value) => Optional.of(value))
              .orElseGetAsync(() => assetKey
                  .map((key) => _loadJsonDataFromAssets(context, key))
                  .orElse(Future.value(Optional<J>.empty()))))
          .catchError(print);

  // TODO(SF) STYLE replace null checks everywhere with optionals?
  StreamController<T> loadData<T, J>({
    BuildContext context,
    Optional<String> remoteUrl,
    Optional<String> appStorageKey,
    Optional<String> assetKey,
    T Function(J) fromJson,
  }) {
    // TODO(SF) STATE error handling
    final streamController = StreamController<T>();
    remoteUrl.ifPresent((url) => _loadRemoteJsonData(url).then(
          (result) => result.ifPresent((json) {
            final data = fromJson(json);
            // TODO(SF) STATE what if already closed?
            streamController.add(data);
            streamController.close();
            appStorageKey.ifPresent((key) => _appStorage.storeJson(key, json));
          }, orElse: () {
            // TODO(SF) STATE close stream if fallback data was loaded already
          }),
        ));
    appStorageKey.ifPresent(
      (key) => _loadOfflineJsonData(
        context: context,
        appStorageKey: key,
        assetKey: assetKey,
      ).then((value) => value.ifPresent((json) {
            final data = fromJson(json);
            if (!streamController.isClosed) {
              streamController.add(data);
              // TODO(SF) STATE close stream if loading remote data failed
            }
          })),
    );

    return streamController;
  }
}
