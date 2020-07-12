import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/enhanced_event.dart';
import '../utils/logging.dart';
import 'my_schedule.dart';
import 'schedule.dart';

// TODO(SF) STATE would a provider family be better?
// for event scheduled & maybe is playing state
// (day2 would get updated too, if only day1 has changed)
// https://github.com/rrousselGit/river_pod/issues/24
class CombinedScheduleProvider
    extends Computed<AsyncValue<ImmortalList<EnhancedEvent>>> {
  CombinedScheduleProvider(this.tag)
      : super((read) {
          final eventController =
              read(dimeGet<ScheduleFilterProvider>(tag: tag));
          final provider = dimeGet<MyScheduleProvider>();
          final myScheduleController = read(provider);
          final mySchedule = read(provider.state);
          return eventController.when(
            data: (eventList) => mySchedule.when(
              data: (mySchedule) {
                _log.debug(
                  'Computing for ${tag ?? "all bands"}',
                );
                return AsyncValue.data(
                  eventList.map((event) => EnhancedEvent(
                        event: event,
                        notificationId: mySchedule.getNotificationId(event.id),
                        // TODO(SF) STATE better use dimeGet<MyScheduleProvider>
                        // ().read(context).toggleEvent(event),
                        toggleEvent: () =>
                            myScheduleController.toggleEvent(event),
                      )),
                );
              },
              loading: () => const AsyncValue.loading(),
              error: (error, stack) {
                _log.error(
                    'Error retrieving my schedule for ${tag ?? "all bands"}, '
                    'computing failed',
                    error,
                    stack);
                return AsyncValue.error(error, stack);
              },
            ),
            loading: () => const AsyncValue.loading(),
            error: (error, stack) {
              _log.error(
                  'Error retrieving events for ${tag ?? "all bands"}, '
                  'computing failed',
                  error,
                  stack);
              return AsyncValue.error(error, stack);
            },
          );
        });

  final String tag;

  static Logger get _log => const Logger('COMBINED_SCHEDULE');
}
