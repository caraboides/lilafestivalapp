import 'package:immortal/immortal.dart';

import '../models/global_config.dart';
import '../models/reference.dart';

final GlobalConfig config = GlobalConfig(
  periodicRebuildDuration: Duration(minutes: 1),
  privacyPolicyUrl: 'https://bit.ly/2L3HSD8',
  repositoryUrl: 'https://github.com/caraboides/lilafestivalapp',
  creators: ImmortalList([
    Reference(
      label: 'Stephanie Freitag',
      links: ImmortalList([
        Link(url: 'https://github.com/strangeAeon'),
      ]),
    ),
    Reference(
      label: 'Christian Hennig',
      links: ImmortalList([
        Link(url: 'https://github.com/caraboides'),
        Link(
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
        Link(url: 'https://openweathermap.org'),
      ]),
    ),
  ]),
);
