import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather/weather_library.dart';
import 'package:optional/optional.dart';

import '../services/open_weather.dart';
import '../utils/combined_key.dart';

class WeatherKey extends CombinedKey<int, DateTime> {
  const WeatherKey({
    @required int cacheKey,
    @required DateTime date,
  }) : super(key1: cacheKey, key2: date);

  int get cacheKey => key1;
  DateTime get date => key2;
}

class WeatherProvider
    extends FutureProviderFamily<Optional<Weather>, WeatherKey> {
  WeatherProvider()
      : super((ref, weatherKey) => dimeGet<OpenWeather>()
            .getWeatherForDate(weatherKey.date, weatherKey.cacheKey));
}
