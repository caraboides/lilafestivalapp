import 'dart:async';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/combined_storage.dart';

// TODO(SF) STATE Autodispose stream provider?
class CombinedStorageStreamProvider<T> extends StreamProvider<T> {
  CombinedStorageStreamProvider({
    BuildContext context,
    String remoteUrl,
    String appStorageKey,
    String assetPath,
    T Function(dynamic) fromJson,
  }) : super((ref) => loadData(
              context: context,
              ref: ref,
              remoteUrl: remoteUrl,
              appStorageKey: appStorageKey,
              assetPath: assetPath,
              fromJson: fromJson,
            ));

  // TODO(SF) FEATURE retry loading remote data later?
  // TODO(SF) watch https://github.com/rrousselGit/river_pod/issues/42
  @visibleForTesting
  static Stream<T> loadData<T, J>({
    BuildContext context,
    String remoteUrl,
    String appStorageKey,
    String assetPath,
    T Function(J) fromJson,
    ProviderReference ref,
  }) {
    final streamController = dimeGet<CombinedStorage>().loadData(
      context: context,
      remoteUrl: remoteUrl,
      appStorageKey: appStorageKey,
      assetPath: assetPath,
      fromJson: fromJson,
    );
    ref.onDispose(streamController.close);

    return streamController.stream;
  }
}
