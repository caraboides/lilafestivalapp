import 'dart:convert';

import 'package:dcache/dcache.dart';
import 'package:dime/dime.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:immortal/immortal.dart';
import 'package:weather/weather_library.dart';
import 'package:http/http.dart' as http;

import '../models/festival_config.dart';
import '../models/global_config.dart';

// TODO(SF) ERROR HANDLING
class OpenWeather {
  final _cache =
      SimpleCache<int, ImmortalList<Weather>>(storage: SimpleStorage(size: 1));

  GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  String _buildQueryUrl() => 'http://api.openweathermap.org/data/2.5/forecast?'
      'lat=${_config.weatherGeoLocation.lat}&'
      'lon=${_config.weatherGeoLocation.lng}&'
      'appid=${_globalConfig.weatherApiKey}&'
      'lang=${I18n.language}';

  Future<Map<String, dynamic>> _requestOpenWeatherAPI() async {
    final response = await http.get(_buildQueryUrl());
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw OpenWeatherAPIException(
          'The API threw an exception: ${response.body}');
    }
  }

  /// For API documentation, see: https://openweathermap.org/forecast5
  Future<ImmortalList<Weather>> _loadForecast() async {
    try {
      final jsonForecasts = await _requestOpenWeatherAPI();
      return ImmortalList(jsonForecasts['list']).map((w) => Weather(w));
    } catch (exception) {
      print(exception);
    }
    return ImmortalList<Weather>();
  }

  Future<ImmortalList<Weather>> getForecast(int hour) async {
    final currentWeathers = _cache.get(hour);
    if (currentWeathers != null) {
      return Future.value(currentWeathers);
    } else {
      return _loadForecast().then((weathers) {
        _cache.set(hour, weathers);
        return Future.value(weathers);
      });
    }
  }
}
