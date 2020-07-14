import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/band_with_events.dart';
import '../models/event.dart';
import '../utils/combined_async_value.dart';
import 'bands.dart';
import 'schedule.dart';

class BandWithEventsProvider
    extends ComputedFamily<AsyncValue<BandWithEvents>, String> {
  BandWithEventsProvider()
      : super((read, bandName) {
          final bandProvider = read(dimeGet<BandProvider>()(bandName));
          final eventsForBandsProvider =
              read(dimeGet<BandScheduleProvider>()(bandName));
          return combineAsyncValues<BandWithEvents, Optional<Band>,
              ImmortalList<Event>>(
            bandProvider,
            eventsForBandsProvider,
            (band, events) => BandWithEvents(
              band: band,
              bandName: bandName,
              events: events,
            ),
          );
        });
}

class BandsWithEventsProvider
    extends Computed<AsyncValue<ImmortalList<BandWithEvents>>> {
  BandsWithEventsProvider()
      : super((read) {
          final bandsProvider = read(dimeGet<SortedBandsProvider>());
          final schedule = read(dimeGet<SortedScheduleProvider>());
          return combineAsyncValues<
              ImmortalList<BandWithEvents>,
              ImmortalList<Band>,
              ImmortalList<Event>>(bandsProvider, schedule, (bands, events) {
            final eventsByBand = events.asMapOfLists((event) => event.bandName);
            return bands.map(
              (band) => BandWithEvents(
                band: Optional.of(band),
                events: eventsByBand[band.name].orElse(ImmortalList<Event>()),
                bandName: band.name,
              ),
            );
          });
        });
}
