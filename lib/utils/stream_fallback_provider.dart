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
  }) : super((ref) => loadData(
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
          .then((json) =>
              Optional<J>.ofNullable(json != null ? jsonDecode(json) : null))
          .catchError((e) {
        print(e);
        return Optional<J>.empty();
      });

  static void _loadRemoteData<J>(
    String remoteUrl,
    void Function(J) handleJsonData,
  ) =>
      _festivalHub
          .loadJsonData<J>(remoteUrl)
          .then((result) => result.ifPresent(handleJsonData))
          .catchError(print);

  static void _loadFallbackData<J>({
    BuildContext context,
    String appStorageKey,
    Optional<String> fallbackDataAssetKey,
    void Function(J) handleJsonFallbackData,
  }) =>
      _appStorage
          .loadJson<J>(appStorageKey)
          .then((result) => result
              .map((value) => Optional.of(value))
              .orElseGetAsync(() => fallbackDataAssetKey
                  .map((assetKey) => _loadJsonDataFromAssets(context, assetKey))
                  .orElse(Future.value(Optional<J>.empty()))))
          .then(
            (value) => value.ifPresent(handleJsonFallbackData),
          )
          .catchError(print);

  // TODO(SF) replace null checks everywhere with optionals?
  // TODO(SF) retry loading remote data later?
  static Stream<T> loadData<T, J>({
    BuildContext context,
    Optional<String> fallbackDataAssetKey,
    Optional<String> appStorageKey,
    Optional<String> remoteUrl,
    T Function(J) fromJson,
    ProviderReference ref,
  }) {
    // TODO(SF) error handling
    final streamController = StreamController<T>();
    remoteUrl.ifPresent(
      (url) => _loadRemoteData(url, (json) {
        final data = fromJson(json);
        // TODO(SF) what if already closed?
        streamController.add(data);
        streamController.close();
        appStorageKey.ifPresent((key) => _appStorage.storeJson(key, json));
      }),
    );
    appStorageKey.ifPresent(
      (key) => _loadFallbackData(
          context: context,
          appStorageKey: key,
          fallbackDataAssetKey: fallbackDataAssetKey,
          handleJsonFallbackData: (json) {
            final data = fromJson(json);
            if (!streamController.isClosed) {
              streamController.add(data);
            }
          }),
    );

    // TODO(SF) possible to close closed stream?
    ref.onDispose(streamController.close);

    return streamController.stream;
  }
}
