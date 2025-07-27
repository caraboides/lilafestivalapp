import 'dart:convert';
import 'dart:io';

import 'package:optional/optional_internal.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/logging.dart';

class AppStorage {
  String? directory;

  Logger get _log => const Logger(module: 'APP_STORAGE');

  Future<String> _getDirectory() async =>
      directory ??= (await getApplicationDocumentsDirectory()).path;

  Future<File> _getFileHandle(String fileName) async {
    final directory = await _getDirectory();
    return File('$directory/$fileName');
  }

  Future<Optional<J>> loadJson<J>(String fileName) async {
    try {
      _log.debug('Reading data from $fileName');
      final file = await _getFileHandle(fileName);
      if (file.existsSync()) {
        final fileContent = await file.readAsString();
        final json = jsonDecode(fileContent) as J;
        _log.debug('Reading data from $fileName was successful');
        return Optional.of(json);
      } else {
        _log.debug('File $fileName does not exist');
      }
    } catch (error) {
      _log.error('Error reading data from $fileName', error);
    }
    return const Optional.empty();
  }

  Future<void> storeJson(String fileName, dynamic json) async {
    try {
      _log.debug('Storing data in $fileName');
      final file = await _getFileHandle(fileName);
      final fileContent = jsonEncode(json);
      await file.create(recursive: true);
      await file.writeAsString(fileContent);
      _log.debug('Storing data in $fileName was successful');
    } catch (error) {
      _log.error('Error storing data in $fileName', error);
    }
  }

  Future<void> removeFile(String fileName) async {
    try {
      _log.debug('Removing file $fileName');
      final file = await _getFileHandle(fileName);
      await file.delete();
      _log.debug('Removing file $fileName was successful');
    } catch (error) {
      _log.error('Error removing file $fileName', error);
    }
  }
}
