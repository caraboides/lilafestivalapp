import 'dart:async';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';

import '../services/combined_storage.dart';

class CombinedStorageStreamProvider<T> extends StreamProvider<T> {
  CombinedStorageStreamProvider({
    BuildContext context,
    Optional<String> remoteUrl,
    Optional<String> appStorageKey,
    Optional<String> assetKey,
    T Function(dynamic) fromJson,
  }) : super((ref) => loadData(
              context: context,
              ref: ref,
              remoteUrl: remoteUrl,
              appStorageKey: appStorageKey,
              assetKey: assetKey,
              fromJson: fromJson,
            ));

  // TODO(SF) retry loading remote data later?
  static Stream<T> loadData<T, J>({
    BuildContext context,
    Optional<String> remoteUrl,
    Optional<String> appStorageKey,
    Optional<String> assetKey,
    T Function(J) fromJson,
    ProviderReference ref,
  }) {
    final streamController = dimeGet<CombinedStorage>().loadData(
      context: context,
      remoteUrl: remoteUrl,
      appStorageKey: appStorageKey,
      assetKey: assetKey,
      fromJson: fromJson,
    );
    // TODO(SF) possible to close closed stream?
    ref.onDispose(streamController.close);

    return streamController.stream;
  }
}
