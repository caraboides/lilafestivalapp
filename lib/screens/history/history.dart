import 'package:flutter/material.dart';

import '../../models/app_route.dart';
import '../../providers/festival_scope.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import '../../widgets/history_wrapper.dart';
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

  @override
  Widget build(BuildContext context) => HistoryWrapper(
        festivalScope: FestivalScope(
          festivalId: festivalId,
          title: festivalTitle,
        ),
        child: const FullSchedule(),
      );
}
