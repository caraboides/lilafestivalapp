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

typedef BandWithEventsProvider
    = ProviderFamily<AsyncValue<BandWithEvents>, BandKey>;

typedef BandsWithEventsProvider
    = ProviderFamily<AsyncValue<ImmortalMap<String, BandWithEvents>>, String>;

typedef SortedBandsWithEventsProvider
    = ProviderFamily<AsyncValue<ImmortalList<BandWithEvents>>, String>;

// ignore: avoid_classes_with_only_static_members
class BandsWithEventsProviderCreator {
  static BandWithEventsProvider createBandWithEventsProvider() =>
      Provider.family<AsyncValue<BandWithEvents>, BandKey>((ref, key) {
        final bandProvider = ref.read(dimeGet<BandProvider>()(key));
        final eventsForBandsProvider =
            ref.read(dimeGet<BandScheduleProvider>()(key));
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
      });

  static BandsWithEventsProvider create() =>
      Provider.family<AsyncValue<ImmortalMap<String, BandWithEvents>>, String>(
          (ref, festivalId) {
        final bandsProvider = ref.read(dimeGet<BandsProvider>()(festivalId));
        final schedule =
            ref.read(dimeGet<SortedScheduleProvider>()(festivalId));
        return combineAsyncValues<
            ImmortalMap<String, BandWithEvents>,
            ImmortalMap<String, Band>,
            ImmortalList<Event>>(bandsProvider, schedule, (bands, events) {
          final eventsByBand = events.asMapOfLists((event) => event.bandName);
          return bands.mapValues(
            (bandName, band) => BandWithEvents(
              bandName: bandName,
              band: Optional.of(band),
              events: eventsByBand[band.name].orElse(ImmortalList<Event>()),
            ),
          );
        });
      });

  static SortedBandsWithEventsProvider createSortedBandsWithEventsProvider() =>
      Provider.family<AsyncValue<ImmortalList<BandWithEvents>>, String>(
          (ref, festivalId) => ref
              .read(dimeGet<BandsWithEventsProvider>()(festivalId))
              .whenData((bands) => bands.values
                  .sort((a, b) => a.bandName.compareTo(b.bandName))));
}
