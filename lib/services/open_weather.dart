import 'dart:convert';
import 'dart:math';

import 'package:dcache/dcache.dart';
import 'package:dime/dime.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:immortal/immortal.dart';
import 'package:weather/weather_library.dart';
import 'package:http/http.dart' as http;
import 'package:optional/optional.dart';

import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/date.dart';
import '../utils/logging.dart';

class OpenWeather {
  final _cache =
      SimpleCache<int, ImmortalList<Weather>>(storage: SimpleStorage(size: 1));

  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger('WEATHER');

  String _buildQueryUrl() => 'http://api.openweathermap.org/data/2.5/forecast?'
      'lat=${_config.weatherGeoLocation.lat}&'
      'lon=${_config.weatherGeoLocation.lng}&'
      'appid=${_globalConfig.weatherApiKey}&'
      'lang=${I18n.language}';

  /// For API documentation, see: https://openweathermap.org/forecast5
  Future<Optional<ImmortalList<Weather>>> _loadForecast() async {
    try {
      final response = await http.get(_buildQueryUrl());
      if (response.statusCode == 200) {
        final jsonForecasts = json.decode(response.body);
        _log.debug('Loading forecast was successful');
        final weathers =
            ImmortalList(jsonForecasts['list']).map((w) => Weather(w));
        return Optional.of(weathers);
      } else {
        _log.error('Loading forecast failed', response.body);
      }
    } catch (error) {
      _log.error('Error loading forecast', error);
    }
    return const Optional<ImmortalList<Weather>>.empty();
  }

  Future<ImmortalList<Weather>> _getForecast(int hour) async {
    // TODO(SF) STYLE knowledge about cache key in two locations
    final currentWeathers = _cache.get(hour);
    if (currentWeathers != null) {
      _log.debug('Reading forecast for hour $hour from cache');
      return Future.value(currentWeathers);
    }
    _log.debug('Loading forecast for hour $hour');
    return _loadForecast().then((weathers) => weathers.map((list) {
          _log.debug(
            'Loading weather for hour $hour was successful, writing to cache',
          );
          _cache.set(hour, list);
          return list;
        }).orElse(ImmortalList<Weather>()));
  }

  Future<Optional<Weather>> getWeatherForDate(DateTime date) async {
    _log.debug('Loading weather for $date');
    final forecast = await _getForecast(date.hour);
    _log.debug('Selecting weather for $date');
    final now = DateTime.now();
    final isToday = isSameFestivalDay(now, date);
    final minHour = isToday ? max(14, now.hour) : 14;
    return forecast.lastWhere((current) =>
        isSameFestivalDay(current.date, date) &&
        current.date.hour <= minHour &&
        current.date.hour >= 14);
  }
}
