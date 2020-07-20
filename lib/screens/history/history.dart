import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../models/app_route.dart';
import '../../models/festival_config.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import 'history.i18n.dart';

class History extends StatelessWidget {
  const History({
    this.festivalId,
    this.festivalTitle,
  });

  final String festivalId;
  final String festivalTitle;

  static Widget builder(BuildContext context, NestedRoute nestedRoute) =>
      History(
        festivalId: nestedRoute.key,
        festivalTitle: nestedRoute.title,
      );

  static String title() => 'History'.i18n;

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  /* TODO(SF) HISTORY
   * - handle missing running order
   * - write history data to cache only
   * > https://pub.dev/packages/flutter_cache_manager
   * - handle my schedule legacy file
   * - use different theme to differentiate from the current festival?
   */

  // TODO(SF) HISTORY use different empty schedule text for history?
  // TODO(SF) HISTORY calculate days from events
  @override
  Widget build(BuildContext context) => FullSchedule(
        festivalId: festivalId,
        titleWidget: Text('${_config.festivalName} $festivalTitle'),
        days: ImmortalList<DateTime>(),
      );
}
