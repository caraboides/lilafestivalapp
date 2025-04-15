import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather/weather.dart';

import '../../../models/festival_config.dart';
import '../../../models/theme.dart';
import '../../../providers/weather.dart';
import '../../../utils/date.dart';
import '../../../utils/logging.dart';

class WeatherCard extends HookConsumerWidget {
  const WeatherCard(this.date, {super.key});

  final DateTime date;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  WeatherProvider get _weather => dimeGet<WeatherProvider>();
  Logger get _log => const Logger(module: 'WeatherCard');
  Uri get _weatherUrl =>
      Uri.parse('https://openweathermap.org/city/${_config.weatherCityId}');

  Widget _buildWeatherWidget(Weather weather) => InkWell(
    onTap: () => launchUrl(_weatherUrl, mode: LaunchMode.externalApplication),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // TODO(SF) FEATURE option for temperature unit?
          if (weather.temperature?.celsius != null)
            Text('${weather.temperature!.celsius!.toStringAsFixed(1)}°C'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.network(
              'http://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
            ),
          ),
          if (weather.weatherDescription != null)
            Flexible(
              fit: FlexFit.loose,
              child: Text(
                weather.weatherDescription!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    ),
  );

  Widget _buildWeatherCard(Weather weather) => Card(
    child: SizedBox(
      height: _theme.cardBannerHeight,
      child: _buildWeatherWidget(weather),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Update weather every hour
    final hour = currentDate().hour;
    final weather = ref.watch(_weather(WeatherKey(date: date, cacheKey: hour)));
    final lastWeather = useState<Widget?>(null);
    final fallback = lastWeather.value ?? Container();
    return weather.when(
      data:
          (result) => result
              .map((weather) {
                final weatherCard = _buildWeatherCard(weather);
                lastWeather.value = weatherCard;
                return weatherCard;
              })
              .orElse(fallback),
      loading: () => fallback,
      error: (error, trace) {
        _log.error(
          'Error retrieving weather for ${date.toIso8601String()}@$hour',
          error,
          trace,
        );
        return fallback;
      },
    );
  }
}
