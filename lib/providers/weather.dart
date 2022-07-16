import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:optional/optional.dart';
import 'package:weather/weather.dart';

import '../models/combined_key.dart';
import '../services/open_weather.dart';

class WeatherKey extends CombinedKey<int, DateTime> {
  const WeatherKey({
    required int cacheKey,
    required DateTime date,
  }) : super(key1: cacheKey, key2: date);

  int get cacheKey => key1;
  DateTime get date => key2;
}

typedef WeatherProvider
    = AutoDisposeStreamProviderFamily<Optional<Weather>, WeatherKey>;

class WeatherProviderCreator {
  static OpenWeather get _weather => dimeGet<OpenWeather>();

  static WeatherProvider create() =>
      StreamProvider.autoDispose.family<Optional<Weather>, WeatherKey>(
          (ref, weatherKey) => _weather.getWeatherForDate(weatherKey.date));
}
