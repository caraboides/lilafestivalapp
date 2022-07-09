import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:tuple/tuple.dart';

import '../../../../models/event.dart';
import '../../../../providers/festival_scope.dart';
import '../../../../providers/filtered_schedules.dart';
import '../../../../providers/schedule.dart';
import '../../../../utils/combined_async_values.dart';
import '../../../../utils/logging.dart';
import '../../../messages/error_screen/error_screen.dart';
import '../../../messages/loading_screen/loading_screen.dart';
import '../empty_schedule/empty_schedule.dart';
import '../event_list_view.dart';
import 'daily_schedule_list.i18n.dart';

class DailyScheduleList extends HookConsumerWidget {
  const DailyScheduleList(
    this.date, {
    this.likedOnly = false,
    Key? key,
  }) : super(key: key);

  final DateTime date;
  final bool likedOnly;

  Logger get _log => const Logger(module: 'DailyScheduleList');

  Widget _buildErrorScreen() =>
      ErrorScreen('There was an error retrieving the running order.'.i18n);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalId = DimeFlutter.get<FestivalScope>(context).festivalId;
    final mapProvider =
        ref.watch(dimeGet<DailyScheduleMapProvider>()(DailyScheduleKey(
      festivalId: festivalId,
      date: date,
    )));
    final listProvider =
        ref.watch(dimeGet<FilteredDailyScheduleProvider>()(DailyScheduleFilter(
      festivalId: festivalId,
      date: date,
      likedOnly: likedOnly,
    )));
    return combineAsyncValues(mapProvider, listProvider,
            Tuple2<ImmortalMap<String, Event>, ImmortalList<String>>.new)
        .when(
      data: (eventTuple) {
        if (eventTuple.item1.isEmpty) {
          return _buildErrorScreen();
        }
        return AnimatedCrossFade(
          firstChild: const EmptySchedule(),
          secondChild: EventListView(
            events: eventTuple.item1,
            eventIds: eventTuple.item2,
            date: date,
          ),
          crossFadeState: eventTuple.item2.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 350),
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
