import 'dart:async';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/combined_storage.dart';

Stream<T> createCombinedStorageStream<T, J>({
  required BuildContext context,
  required String remoteUrl,
  required String appStorageKey,
  required String assetPath,
  required T Function(J) fromJson,
  required Ref ref,
  Duration? periodicDuration,
}) {
  final streamController = dimeGet<CombinedStorage>().loadData(
    context: context,
    remoteUrl: remoteUrl,
    appStorageKey: appStorageKey,
    assetPath: assetPath,
    fromJson: fromJson,
    periodicDuration: periodicDuration,
  );
  ref.onDispose(streamController.close);

  return streamController.stream;
}
