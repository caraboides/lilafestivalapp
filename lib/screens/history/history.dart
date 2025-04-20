import 'package:flutter/material.dart';

import '../../models/app_route.dart';
import '../../models/ids.dart';
import '../../providers/festival_scope.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import '../../widgets/history/history_wrapper.dart';
import 'history.i18n.dart';

class History extends StatelessWidget {
  const History({required this.festivalId, required this.festivalTitle});

  final FestivalId festivalId;
  final String festivalTitle;

  static Widget builder(BuildContext context, NestedRoute nestedRoute) =>
      History(festivalId: nestedRoute.key, festivalTitle: nestedRoute.title);

  static String path = '/history';
  static String title() => 'History'.i18n;

  @override
  Widget build(BuildContext context) => HistoryWrapper(
    festivalScope: HistoryFestivalScope(
      festivalId: festivalId,
      title: festivalTitle,
    ),
    child: const FullSchedule(),
  );
}
