import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/filtered_schedules.dart';
import '../../../../utils/logging.dart';
import '../../../error_screen/error_screen.dart';
import '../../../loading_screen/loading_screen.dart';
import '../empty_schedule/empty_schedule.dart';
import '../event_list_view.dart';
import 'daily_schedule_list.i18n.dart';

class DailyScheduleList extends HookWidget {
  const DailyScheduleList(
    this.date, {
    @required this.festivalId,
    this.likedOnly = false,
    Key key,
  }) : super(key: key);

  final DateTime date;
  final String festivalId;
  final bool likedOnly;

  Logger get _log => const Logger(module: 'DailyScheduleList');

  Widget _buildErrorScreen() =>
      ErrorScreen('There was an error retrieving the running order.'.i18n);

  @override
  Widget build(BuildContext context) {
    // TODO(SF) HISTORY pass festival id
    final provider = useProvider(dimeGet<FilteredDailyScheduleProvider>()(
        DailyScheduleFilter(date, likedOnly: likedOnly)));
    return provider.when(
      data: (events) {
        if (events.isEmpty) {
          return likedOnly ? const EmptySchedule() : _buildErrorScreen();
        }
        return EventListView(
          events: events,
          date: date,
        );
      },
      loading: () => LoadingScreen('Loading running order.'.i18n),
      error: (error, trace) {
        _log.error(
            'Error retrieving ${likedOnly ? "filtered" : "full"} schedule for '
            '${date.toIso8601String()}',
            error,
            trace);
        return _buildErrorScreen();
      },
    );
  }
}