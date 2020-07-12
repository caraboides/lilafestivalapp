import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  error,
}

class Logger {
  const Logger(this.module);

  final String module;

  // TODO(SF) STYLE improve
  void Function(String) _logFunction(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        // TODO(SF) STYLE hide in production mode and during tests
        return (message) => debugPrint('[DEBUG] $_logModule$message');
      case LogLevel.error:
        return (message) => print('[ERROR] $_logModule$message');
      default:
        return (message) => print('[INFO] $_logModule$message');
    }
  }

  String get _logModule => module != null ? '$module: ' : '';

  void debug(String message) => _logFunction(LogLevel.debug)(message);

  void error(String message, dynamic error) =>
      _logFunction(LogLevel.error)('$message: ${error?.toString()}');
}
