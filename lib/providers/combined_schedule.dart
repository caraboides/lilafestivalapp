import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../models/scheduled_event.dart';
import 'my_schedule.dart';
import 'schedule.dart';

// TODO(SF) would a provider family be better?
// for event liked & maybe is playing state
// (day2 would get updated too, if only day1 has changed)
// https://github.com/rrousselGit/river_pod/issues/24
class CombinedScheduleProvider
    extends Computed<AsyncValue<ImmortalList<ScheduledEvent>>> {
  CombinedScheduleProvider(this.tag)
      : super((read) {
          final eventController =
              read(dimeGet<ScheduleFilterProvider>(tag: tag));
          final provider = dimeGet<MyScheduleProvider>();
          final myScheduleController = read(provider);
          final mySchedule = read(provider.state);
          return eventController.when(
            data: (eventList) => mySchedule.whenData(
              (mySchedule) => eventList.map((event) => ScheduledEvent(
                    event: event,
                    isLiked: mySchedule.isEventLiked(event.id),
                    toggleEvent: () => myScheduleController.toggleEvent(event),
                  )),
            ),
            loading: () => AsyncValue.loading(),
            error: (err, stack) => AsyncValue.error(err, stack),
          );
        });

  final String tag;
}
