import 'package:dime/dime.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/band_key.dart';
import '../models/band_with_events.dart';
import '../models/event.dart';
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

class BandsWithEventsProvider extends Family<
    Computed<AsyncValue<ImmortalMap<String, BandWithEvents>>>, String> {
  BandsWithEventsProvider()
      : super(
          (festivalId) => Computed((read) {
            final bandsProvider = read(dimeGet<BandsProvider>()(festivalId));
            final schedule =
                read(dimeGet<SortedScheduleProvider>()(festivalId));
            return combineAsyncValues<
                ImmortalMap<String, BandWithEvents>,
                ImmortalMap<String, Band>,
                ImmortalList<Event>>(bandsProvider, schedule, (bands, events) {
              final eventsByBand =
                  events.asMapOfLists((event) => event.bandName);
              return bands.mapValues(
                (bandName, band) => BandWithEvents(
                  bandName: bandName,
                  band: Optional.of(band),
                  events: eventsByBand[band.name].orElse(ImmortalList<Event>()),
                ),
              );
            });
          }),
        );
}

class SortedBandsWithEventsProvider
    extends Family<Computed<AsyncValue<ImmortalList<BandWithEvents>>>, String> {
  SortedBandsWithEventsProvider()
      : super((festivalId) => Computed((read) =>
            read(dimeGet<BandsWithEventsProvider>()(festivalId)).whenData(
                (bands) => bands.values
                    .sort((a, b) => a.bandName.compareTo(b.bandName)))));
}
