import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'logging.dart';

Logger get _log => const Logger(module: 'CACHE_STREAM');

Stream<T> createCacheStream<T, J>({
  @required String remoteUrl,
  @required T Function(J) fromJson,
}) {
  _log.debug('Loading data from $remoteUrl');
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
