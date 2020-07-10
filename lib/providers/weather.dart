import 'dart:math';

import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:weather/weather_library.dart';
import 'package:optional/optional.dart';

import '../services/open_weather.dart';
import '../utils/date.dart';

class WeatherParameters {
  const WeatherParameters(this.date, this.hour);
  final DateTime date;
  final int hour;
}

class WeatherProvider
    extends FutureProviderFamily<Optional<Weather>, DateTime> {
  WeatherProvider()
      : super((ref, date) => dimeGet<OpenWeather>().getForecast(date.hour).then(
              (forecast) => _selectWeatherForDate(forecast, date),
            ));

  static Optional<Weather> _selectWeatherForDate(
      ImmortalList<Weather> forecast, DateTime date) {
    final now = DateTime.now();
    // TODO(SF) WEATHER or should this only check for actual day?
    final isToday = isSameFestivalDay(now, date);
    final minHour = isToday ? max(14, now.hour) : 14;
    return forecast.lastWhere((current) =>
        // TODO(SF) WEATHER as above - or same actual day?
        isSameFestivalDay(current.date, date) &&
        current.date.hour <= minHour &&
        current.date.hour >= 14);
  }
}
