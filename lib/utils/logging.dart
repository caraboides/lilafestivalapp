import 'package:flutter/foundation.dart';

typedef LogFunction = void Function(String);

// Hide debug prints in release mode
final LogFunction _debugPrint = kReleaseMode ? (_) {} : debugPrint;

class Logger {
  const Logger(this.module);

  final String module;

  String get _logModule => module != null ? '$module: ' : '';

  LogFunction _logFunction([
    String logLevel = 'INFO',
    LogFunction logFunction = print,
  ]) =>
      (message) => logFunction('[$logLevel] $_logModule$message');

  LogFunction get _logDebug => _logFunction('DEBUG', _debugPrint);

  LogFunction get _logError => _logFunction('ERROR');

  void debug(String message) => _logDebug(message);

  void error(String message, dynamic error, [StackTrace trace]) =>
      _logError('$message: ${error?.toString()}'
          '${trace != null ? " ${trace.toString()}" : ""}');
}
