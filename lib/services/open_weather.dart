import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';
import 'package:weather/weather.dart';

import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/cache_stream.dart';
import '../utils/constants.dart';
import '../utils/date.dart';
import '../utils/logging.dart';

// TODO(SF): STATE create custom cache manager for history as well
class WeatherCacheManager extends CacheManager {
  WeatherCacheManager()
    : super(
        Config(
          Constants.weatherCacheKey,
          stalePeriod: const Duration(hours: 1),
          maxNrOfCacheObjects: 1,
        ),
      );
}

class OpenWeather {
  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  WeatherCacheManager get _cache => dimeGet<WeatherCacheManager>();
  Logger get _log => const Logger(module: 'WEATHER');

  String _buildQueryUrl() =>
      '${_globalConfig.weatherBaseUrl}/forecast?'
      'lat=${_config.weatherGeoLocation.lat}&'
      'lon=${_config.weatherGeoLocation.lng}&'
      'appid=${_globalConfig.weatherApiKey}&'
      'lang=${"de"}';

  ImmortalList<Weather> _forecastFromJson(Map<String, dynamic> json) =>
      ImmortalList(json['list']).map((w) => Weather(w));

  /// For API documentation, see: https://openweathermap.org/forecast5
  Stream<ImmortalList<Weather>> _getForecast() => createCacheStream(
    remoteUrl: _buildQueryUrl(),
    fromJson: _forecastFromJson,
    cacheManager: _cache,
  );

  Stream<Optional<Weather>> getWeatherForDate(DateTime date) =>
      _getForecast().map<Optional<Weather>>((forecast) {
        _log.debug('Selecting weather for $date');
        final now = currentDate();
        final isToday = isSameFestivalDay(now, date);
        final maxHour =
            isToday
                ? max(_globalConfig.weatherMinHour, now.hour)
                : _globalConfig.weatherMinHour;
        return forecast.lastWhereOptional(
          (current) => Optional.ofNullable(current.date)
              .map(
                (currentDate) =>
                    isSameFestivalDay(currentDate, date) &&
                    currentDate.hour <= maxHour &&
                    currentDate.hour >= _globalConfig.weatherMinHour,
              )
              .orElse(false),
        );
      });
}
