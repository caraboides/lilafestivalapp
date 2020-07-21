import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/band_with_events.dart';
import '../models/event.dart';
import '../utils/band_key.dart';
import '../utils/combined_async_values.dart';
import 'bands.dart';
import 'schedule.dart';

class BandWithEventsProvider
    extends Family<Computed<AsyncValue<BandWithEvents>>, BandKey> {
  BandWithEventsProvider()
      : super(
          (key) => Computed((read) {
            final bandProvider = read(dimeGet<BandProvider>()(key));
            final eventsForBandsProvider =
                read(dimeGet<BandScheduleProvider>()(key));
            return combineAsyncValues<BandWithEvents, Optional<Band>,
                ImmortalList<Event>>(
              bandProvider,
              eventsForBandsProvider,
              (band, events) => BandWithEvents(
                bandName: key.bandName,
                band: band,
                events: events,
              ),
            );
          }),
        );
}

class BandsWithEventsProvider
    extends Family<Computed<AsyncValue<ImmortalList<BandWithEvents>>>, String> {
  BandsWithEventsProvider()
      : super(
          (festivalId) => Computed((read) {
            final bandsProvider =
                read(dimeGet<SortedBandsProvider>()(festivalId));
            final schedule =
                read(dimeGet<SortedScheduleProvider>()(festivalId));
            return combineAsyncValues<
                ImmortalList<BandWithEvents>,
                ImmortalList<Band>,
                ImmortalList<Event>>(bandsProvider, schedule, (bands, events) {
              final eventsByBand =
                  events.asMapOfLists((event) => event.bandName);
              return bands.map(
                (band) => BandWithEvents(
                  bandName: band.name,
                  band: Optional.of(band),
                  events: eventsByBand[band.name].orElse(ImmortalList<Event>()),
                ),
              );
            });
          }),
        );
}
