import 'package:hooks_riverpod/hooks_riverpod.dart';

AsyncValue<R> combineAsyncValues<R, A, B>(
  AsyncValue<A> value1,
  AsyncValue<B> value2,
  R Function(A, B) combine,
) => value1.when(
  data: (data1) => value2.when(
    data: (data2) => AsyncValue.data(combine(data1, data2)),
    loading: () => const AsyncValue.loading(),
    error: (error, trace) => AsyncValue.error(error, trace),
  ),
  loading: () => const AsyncValue.loading(),
  error: (error, trace) => AsyncValue.error(error, trace),
);
