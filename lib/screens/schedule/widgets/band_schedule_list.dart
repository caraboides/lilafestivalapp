import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/bands_with_events.dart';
import '../../../providers/filtered_schedules.dart';
import '../../../utils/logging.dart';
import 'band_list_view.dart';
import 'empty_schedule.dart';

class BandScheduleList extends HookWidget {
  const BandScheduleList({
    Key key,
    this.likedOnly,
  });

  final bool likedOnly;

  Logger get _log => const Logger('BandScheduleList');

  @override
  Widget build(BuildContext context) {
    // TODO(SF) STATE this does not work, split up widgets, possibly for events
    // as well - ooooor use a family with boolean key
    final provider = likedOnly
        ? dimeGet<FilteredBandScheduleProvider>()
        : dimeGet<BandsWithEventsProvider>();
    return useProvider(provider).when(
      data: (bands) {
        // TODO(SF) ERROR HANDLING list should not be empty > should this be
        // handled & logged sooner?
        if (bands.isEmpty) {
          return likedOnly
              ? EmptySchedule()
              // TODO(SF) THEME
              : const Center(
                  child: Text('Error! Band list should not be empty!'));
        }
        return BandListView(bands: bands);
      },
      // TODO(SF) THEME
      loading: () => const Center(child: Text('Loading!')),
      error: (error, trace) {
        _log.error('Error retrieving band schedule', error, trace);
        return Center(
          child: Text('Error! $error ${trace.toString()}'),
        );
      },
    );
  }
}
