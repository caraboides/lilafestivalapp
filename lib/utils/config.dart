import 'package:immortal/immortal.dart';

import '../models/global_config.dart';
import '../models/reference.dart';

final GlobalConfig config = GlobalConfig(
  periodicRebuildDuration: const Duration(minutes: 1),
  privacyPolicyUrlDe: Uri.parse('https://bit.ly/3IYKdwl'),
  // TODO(SF) I18N translate privacy policy
  privacyPolicyUrlEn: Uri.parse('https://bit.ly/3IYKdwl'),
  festivalHubBaseUrl: const String.fromEnvironment('FESTIVAL_HUB_BASE_URL'),
  repositoryUrl: Uri.parse('https://github.com/caraboides/lilafestivalapp'),
  creators: ImmortalList([
    Reference(
      label: 'Stephanie Freitag',
      links: ImmortalList([
        Link(url: Uri.parse('https://github.com/strangeAeon')),
        Link(
          url: Uri.parse('https://twitter.com/_death_may_die_'),
          label: '@_death_may_die_',
        ),
      ]),
    ),
    Reference(
      label: 'Christian Hennig',
      links: ImmortalList([
        Link(url: Uri.parse('https://github.com/caraboides')),
        Link(
          url: Uri.parse('https://twitter.com/carabiodes'),
          label: '@carabiodes',
        ),
      ]),
    ),
  ]),
  references: ImmortalList([
    Reference(
      label: 'Weather data provided by:',
      links: ImmortalList([
        Link(url: Uri.parse('https://openweathermap.org')),
      ]),
    ),
  ]),
  weatherBaseUrl: 'http://api.openweathermap.org/data/2.5',
  weatherApiKey: const String.fromEnvironment('WEATHER_API_KEY'),
  weatherMinHour: 14,
  scheduleReloadDuration: const Duration(hours: 1),
);
