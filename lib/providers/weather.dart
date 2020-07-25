import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather/weather_library.dart';
import 'package:optional/optional.dart';
// TODO(SF) FIXME
// ignore: implementation_imports
import 'package:riverpod/src/stream_provider/stream_provider.dart';

import '../models/combined_key.dart';
import '../services/open_weather.dart';

class WeatherKey extends CombinedKey<int, DateTime> {
  const WeatherKey({
    @required int cacheKey,
    @required DateTime date,
  }) : super(key1: cacheKey, key2: date);

  int get cacheKey => key1;
  DateTime get date => key2;
}

class WeatherProvider
    extends Family<AutoDisposeStreamProvider<Optional<Weather>>, WeatherKey> {
  WeatherProvider() : super(_createStreamProvider);

  static OpenWeather get _weather => dimeGet<OpenWeather>();

  static AutoDisposeStreamProvider<Optional<Weather>> _createStreamProvider(
          WeatherKey weatherKey) =>
      StreamProvider.autoDispose(
          (ref) => _weather.getWeatherForDate(weatherKey.date));
}
