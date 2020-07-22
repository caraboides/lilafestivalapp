import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../models/app_route.dart';
import '../../models/festival_config.dart';
import '../../providers/festival_scope.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import 'history.i18n.dart';

class History extends StatelessWidget {
  const History({
    this.festivalId,
    this.titleSuffix,
  });

  final String festivalId;
  final String titleSuffix;

  static Widget builder(BuildContext context, NestedRoute nestedRoute) =>
      History(
        festivalId: nestedRoute.key,
        titleSuffix: nestedRoute.title,
      );

  static String title() => 'History'.i18n;

  /* TODO(SF) HISTORY
   * - handle missing running order
   * - add cancelled flag to bands
   * - use different theme to differentiate from the current festival?
   */

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  // TODO(SF) HISTORY use different empty schedule text for history?
  // TODO(SF) HISTORY calculate days from events
  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
        modules: <BaseDimeModule>[
          FestivalScopeModule(FestivalScope(
            festivalId: festivalId,
            titleSuffix: titleSuffix,
          ))
        ],
        child: FullSchedule(
          // TODO(SF) HISTORY move to full schedule?
          titleWidget: Text('${_config.festivalName} $titleSuffix'),
          days: ImmortalList<DateTime>(),
        ),
      );
}
