import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weather/weather_library.dart';
import 'package:optional/optional.dart';

import '../services/open_weather.dart';

class WeatherProvider
    extends FutureProviderFamily<Optional<Weather>, DateTime> {
  WeatherProvider()
      : super((ref, date) => dimeGet<OpenWeather>().getWeatherForDate(date));
}
