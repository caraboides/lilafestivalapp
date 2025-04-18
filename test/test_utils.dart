Future<T> Function(Invocation) mockResponse<T>(
  T data, [
  int delayInMilliseconds = 0,
]) =>
    (_) =>
        Future.delayed(Duration(milliseconds: delayInMilliseconds), () => data);

Future<T> Function(Invocation) mockError<T>([int delayInMilliseconds = 0]) =>
    (_) => Future.delayed(
      Duration(milliseconds: delayInMilliseconds),
      () => throw Exception('Test'),
    );
