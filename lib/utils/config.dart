import 'package:flutter_config/flutter_config.dart';
import 'package:immortal/immortal.dart';

import '../models/global_config.dart';
import '../models/reference.dart';

final GlobalConfig config = GlobalConfig(
  periodicRebuildDuration: const Duration(minutes: 1),
  privacyPolicyUrlDe: 'https://bit.ly/2L3HSD8',
  // TODO(SF) I18N translate privacy policy
  privacyPolicyUrlEn: 'https://bit.ly/2L3HSD8',
  festivalHubBaseUrl: 'https://lilafestivalhub.herokuapp.com',
  repositoryUrl: 'https://github.com/caraboides/lilafestivalapp',
  creators: ImmortalList([
    Reference(
      label: 'Stephanie Freitag',
      links: ImmortalList([
        const Link(url: 'https://github.com/strangeAeon'),
      ]),
    ),
    Reference(
      label: 'Christian Hennig',
      links: ImmortalList([
        const Link(url: 'https://github.com/caraboides'),
        const Link(
          url: 'https://twitter.com/carabiodes',
          label: '@carabiodes',
        ),
      ]),
    ),
  ]),
  references: ImmortalList([
    Reference(
      label: 'Weather data provided by:',
      links: ImmortalList([
        const Link(url: 'https://openweathermap.org'),
      ]),
    ),
  ]),
  weatherApiKey: FlutterConfig.get('WEATHER_API_KEY'),
);
