import 'dart:async';
import 'dart:convert';

import 'package:dime/dime.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'logging.dart';

Logger get _log => const Logger(module: 'CACHE_STREAM');

Stream<T> createCacheStream<T, J>({
  required String remoteUrl,
  required T Function(J) fromJson,
  BaseCacheManager? cacheManager,
}) {
  _log.debug('Loading data from $remoteUrl');
  // TODO(SF): FEATURE with DownloadProgress
  final stream = (cacheManager ?? dimeGet<BaseCacheManager>()).getFileStream(
    remoteUrl,
  );
  return stream.asyncMap<T>((fileResponse) async {
    final info = fileResponse as FileInfo;
    final content = await info.file.readAsString();
    final json = jsonDecode(content) as J;
    _log.debug('Loading data from $remoteUrl was successful');
    return fromJson(json);
  });
}
