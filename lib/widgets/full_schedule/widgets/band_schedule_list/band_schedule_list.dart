import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../providers/filtered_schedules.dart';
import '../../../../utils/logging.dart';
import '../../../error_screen/error_screen.dart';
import '../../../loading_screen/loading_screen.dart';
import '../band_list_view.dart';
import '../empty_schedule/empty_schedule.dart';
import 'band_schedule_list.i18n.dart';

class BandScheduleList extends HookWidget {
  const BandScheduleList({
    Key key,
    @required this.festivalId,
    this.likedOnly = false,
  });

  final String festivalId;
  final bool likedOnly;

  Logger get _log => const Logger(module: 'BandScheduleList');

  Widget _buildErrorScreen() =>
      ErrorScreen('There was an error retrieving the bands.'.i18n);

  @override
  Widget build(BuildContext context) {
    // TODO(SF) HISTORY pass festivalId
    final provider =
        useProvider(dimeGet<FilteredBandScheduleProvider>()(likedOnly));
    return provider.when(
      data: (bands) {
        if (bands.isEmpty) {
          return likedOnly ? const EmptySchedule() : _buildErrorScreen();
        }
        return BandListView(bands);
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