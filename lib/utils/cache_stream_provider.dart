import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'logging.dart';

class CacheStreamProvider<T> extends AutoDisposeStreamProvider<T> {
  CacheStreamProvider({
    @required String remoteUrl,
    @required T Function(dynamic) fromJson,
  }) : super((_) => createStream(
              remoteUrl: remoteUrl,
              fromJson: fromJson,
            ));

  static Logger get _log => const Logger(module: 'CACHE_STREAM');

  @visibleForTesting
  static Stream<T> createStream<T, J>({
    @required String remoteUrl,
    @required T Function(J) fromJson,
  }) {
    _log.debug('Loading data from $remoteUrl');
    // TODO(SF) HISTORY set cache headers
    // TODO(SF) FEATURE with DownloadProgress
    final stream = dimeGet<BaseCacheManager>().getFileStream(remoteUrl);
    return stream.asyncMap<T>((fileResponse) async {
      final info = fileResponse as FileInfo;
      final content = await info.file.readAsString();
      final json = jsonDecode(content);
      _log.debug('Loading data from $remoteUrl was successful');
      return fromJson(json);
    });
  }
}
