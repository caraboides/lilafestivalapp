import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/app_route.dart';
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
   * - add cancelled flag to bands
   * - use different theme to differentiate from the current festival?
   */
  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
        modules: <BaseDimeModule>[
          FestivalScopeModule(FestivalScope(
            festivalId: festivalId,
            titleSuffix: titleSuffix,
          ))
        ],
        child: const FullSchedule(),
      );
}
