import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather/weather_library.dart';
import 'package:optional/optional.dart';
import 'package:quiver/core.dart' as quiver;

import '../services/open_weather.dart';

@immutable
class WeatherKey {
  const WeatherKey(this.date, this.cacheKey);

  final DateTime date;
  final int cacheKey;

  @override
  int get hashCode => quiver.hash2(date.hashCode, cacheKey.hashCode);

  @override
  bool operator ==(dynamic other) =>
      other is WeatherKey && date == other.date && cacheKey == other.cacheKey;
}

class WeatherProvider
    extends FutureProviderFamily<Optional<Weather>, WeatherKey> {
  WeatherProvider()
      : super((ref, weatherKey) => dimeGet<OpenWeather>()
            .getWeatherForDate(weatherKey.date, weatherKey.cacheKey));
}
