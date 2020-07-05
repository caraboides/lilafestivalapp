import 'package:immortal/immortal.dart';

import '../models/festival_config.dart';
import '../models/reference.dart';

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
);
