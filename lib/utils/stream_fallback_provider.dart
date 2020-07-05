import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

import '../services/app_storage.dart';
import '../services/festival_hub.dart';

// TODO(SF) naming
// TODO(SF) write tests
class StreamFallbackProvider<T> extends StreamProvider<T> {
  StreamFallbackProvider({
    BuildContext context,
    Optional<String> remoteUrl,
    Optional<String> appStorageKey,
    Optional<String> fallbackDataAssetKey,
    T Function(dynamic) fromJson,
  }) : super((ref) => _loadData(
              context: context,
              ref: ref,
              remoteUrl: remoteUrl,
              appStorageKey: appStorageKey,
              fallbackDataAssetKey: fallbackDataAssetKey,
              fromJson: fromJson,
            ));

  static AppStorage get _appStorage => dimeGet<AppStorage>();

  static FestivalHub get _festivalHub => dimeGet<FestivalHub>();

  static Future<Optional<J>> _loadJsonDataFromAssets<J>(
    BuildContext context,
    String fallbackDataAssetKey,
  ) =>
      DefaultAssetBundle.of(context)
          .loadString(fallbackDataAssetKey)
          .then((json) => Optional<J>.of(jsonDecode(json)))
          .catchError((_) => Optional<J>.empty());

  // TODO(SF) replace null checks everywhere with optionals?
  // TODO(SF) retry loading remote data later?
  static Stream<T> _loadData<T, J>({
    BuildContext context,
    Optional<String> fallbackDataAssetKey,
    Optional<String> appStorageKey,
    Optional<String> remoteUrl,
    T Function(J) fromJson,
    ProviderReference ref,
  }) {
    // TODO(SF) improve?
    // TODO(SF) error handling
    final streamController = StreamController<T>();
    remoteUrl.ifPresent(
      (url) => _festivalHub.loadJsonData<J>(url).then(
            (result) => result.map((json) {
              final data = fromJson(json);
              // TODO(SF) what if already closed?
              streamController.add(data);
              streamController.close();
              appStorageKey.map((key) => _appStorage.storeJson(key, json));
            }),
          ),
    );
    appStorageKey.ifPresent(
      (key) => _appStorage.loadJson<J>(key).then((result) async {
        if (result.isPresent) {
          return result;
        }
        return fallbackDataAssetKey
            .map((assetKey) => _loadJsonDataFromAssets(context, assetKey))
            .orElse(Future.value(Optional<J>.empty()));
      }).then(
        (value) => value.ifPresent((json) {
          final data = fromJson(json);
          if (!streamController.isClosed) {
            streamController.add(data);
          }
        }),
      ),
    );

    // TODO(SF) possible to close closed stream?
    ref.onDispose(streamController.close);

    return streamController.stream;
  }
}
