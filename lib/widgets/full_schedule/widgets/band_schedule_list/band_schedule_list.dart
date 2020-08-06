import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:immortal/immortal.dart';

import '../../../../models/band_with_events.dart';
import '../../../../providers/bands_with_events.dart';
import '../../../../providers/festival_scope.dart';
import '../../../../providers/filtered_schedules.dart';
import '../../../../utils/combined_async_values.dart';
import '../../../../utils/logging.dart';
import '../../../messages/error_screen/error_screen.dart';
import '../../../messages/loading_screen/loading_screen.dart';
import '../band_list_view.dart';
import '../empty_schedule/empty_schedule.dart';
import 'band_schedule_list.i18n.dart';

class BandScheduleList extends HookWidget {
  const BandScheduleList({
    Key key,
    this.likedOnly = false,
  });

  final bool likedOnly;

  Logger get _log => const Logger(module: 'BandScheduleList');

  Widget _buildErrorScreen() =>
      ErrorScreen('There was an error retrieving the bands.'.i18n);

  @override
  Widget build(BuildContext context) {
    final festivalId = DimeFlutter.get<FestivalScope>(context).festivalId;
    final mapProvider =
        useProvider(dimeGet<BandsWithEventsProvider>()(festivalId));
    final listProvider =
        useProvider(dimeGet<FilteredBandScheduleProvider>()(BandScheduleKey(
      festivalId: festivalId,
      likedOnly: likedOnly,
    )));
    return combineAsyncValues(
        mapProvider,
        listProvider,
        (bandMap, bandList) =>
            Tuple2<ImmortalMap<String, BandWithEvents>, ImmortalList<String>>(
                bandMap, bandList)).when(
      data: (bandTuple) {
        if (bandTuple.item1.isEmpty) {
          return _buildErrorScreen();
        }
        return AnimatedCrossFade(
          firstChild: const EmptySchedule(),
          secondChild: BandListView(
            bands: bandTuple.item1,
            bandIds: bandTuple.item2,
          ),
          crossFadeState: bandTuple.item2.isEmpty
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 350),
        );
      },
      loading: () => LoadingScreen('Loading bands.'.i18n),
      error: (error, trace) {
        _log.error(
            'Error retrieving ${likedOnly ? "filtered" : "full"} band schedule',
            error,
            trace);
        return _buildErrorScreen();
      },
    );
  }
}
