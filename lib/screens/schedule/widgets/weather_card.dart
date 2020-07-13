import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather_library.dart';

import '../../../models/festival_config.dart';
import '../../../models/theme.dart';
import '../../../providers/weather.dart';
import '../../../utils/logging.dart';

class WeatherCard extends StatefulWidget {
  WeatherCard(this.date, {Key key}) : super(key: key);

  final DateTime date;

  @override
  State<StatefulWidget> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  Widget _lastWeather;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  WeatherProvider get _weather => dimeGet<WeatherProvider>();
  Logger get _log => const Logger('WeatherCard');

  Widget _buildWeatherWidget(Weather weather) => InkWell(
        onTap: () =>
            launch('https://openweathermap.org/city/${_config.weatherCityId}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // TODO(SF) FEATURE option for temperature unit?
              Text('${weather.temperature.celsius.toStringAsFixed(1)}°C'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Image.network(
                  'http://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  weather.weatherDescription,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildWeatherCard(Weather weather) => Card(
        child: Container(
          height: _theme.weatherCardHeight,
          child: _buildWeatherWidget(weather),
        ),
      );

  Widget get _fallback => _lastWeather ?? Container();

  @override
  Widget build(BuildContext context) => Consumer((context, read) {
        // Update weather every hour
        final hour = DateTime.now().hour;
        final weatherTime = widget.date.add(Duration(hours: hour));
        return read(_weather(weatherTime)).when(
          data: (result) => result.map((weather) {
            _lastWeather = _buildWeatherCard(weather);
            return _lastWeather;
          }).orElse(_fallback),
          loading: () => _fallback,
          error: (error, trace) {
            _log.error(
                'Error retrieving weather for ${weatherTime.toIso8601String()}',
                error,
                trace);
            return _fallback;
          },
        );
      });
}
