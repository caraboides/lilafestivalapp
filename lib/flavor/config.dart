import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../models/app_route.dart';
import '../models/festival_config.dart';
import '../models/reference.dart';
import 'screens/drive/drive.dart';
import 'screens/faq/faq.dart';

final FestivalConfig config = FestivalConfig(
  festivalId: 'spirit_2019',
  festivalName: 'Test festival',
  festivalFullName: 'Test festival 2020',
  festivalUrl: 'https://www.spirit-festival.com',
  startDate: DateTime(2019, 8, 29),
  endDate: DateTime(2019, 8, 31),
  daySwitchOffset: Duration(hours: 3),
  fontReferences: ImmortalList([
    Reference(
      label: 'No Continue',
      links: ImmortalList([
        Link(
          url: 'http://gomaricefont.web.fc2.com/',
          label: 'Goma Shin',
        ),
      ]),
    ),
  ]),
  aboutMessages: ImmortalList([
    Reference(
      label: 'Seenotrettung ist kein Verbrechen!',
      links: ImmortalList([
        Link(url: 'https://sea-watch.org/'),
      ]),
    ),
  ]),
  stageAlignment: (stage) {
    switch (stage) {
      case 'Mainstage':
        return CrossAxisAlignment.start;
      case 'Stage II':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.center;
    }
  },
  routes: ImmortalList([
    AppRoute(
      path: '/drive',
      name: 'Location',
      icon: Icons.map,
      builder: Drive.builder,
    ),
    AppRoute(
      path: '/faq',
      name: 'FAQ',
      icon: Icons.help,
      builder: FAQ.builder,
    ),
  ]),
);
