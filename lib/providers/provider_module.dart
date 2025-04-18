import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import 'bands.dart';
import 'bands_with_events.dart';
import 'filtered_schedules.dart';
import 'my_schedule.dart';
import 'schedule.dart';
import 'weather.dart';

class ProviderModule extends BaseDimeModule {
  ProviderModule(this.context);

  final BuildContext context;

  @override
  void updateInjections() {
    // Band providers
    addSingle<BandsProvider>(BandsProviderCreator.create(context));
    addSingle<BandProvider>(BandsProviderCreator.createBandProvider());
    // Schedule providers
    addSingle<ScheduleProvider>(ScheduleProviderCreator.create(context));
    addSingle<FestivalDaysProvider>(
      ScheduleProviderCreator.createFestivalDaysProvider(),
    );
    addSingle<SortedScheduleProvider>(
      ScheduleProviderCreator.createSortedProvider(),
    );
    addSingle<DailyScheduleProvider>(
      ScheduleProviderCreator.createDailyScheduleProvider(),
    );
    addSingle<DailyScheduleMapProvider>(
      ScheduleProviderCreator.createDailyScheduleMapProvider(),
    );
    addSingle<BandScheduleProvider>(
      ScheduleProviderCreator.createBandsScheduleProvider(),
    );
    // My Schedule providers
    addSingle<MyScheduleProvider>(MyScheduleProviderCreator.create());
    addSingle<LikedEventProvider>(
      MyScheduleProviderCreator.createLikedEventProvider(),
    );
    // Combined bands and events providers
    addSingle<BandWithEventsProvider>(
      BandsWithEventsProviderCreator.createBandWithEventsProvider(),
    );
    addSingle<BandsWithEventsProvider>(BandsWithEventsProviderCreator.create());
    addSingle<SortedBandsWithEventsProvider>(
      BandsWithEventsProviderCreator.createSortedBandsWithEventsProvider(),
    );
    // Filtered band and event providers
    addSingle<FilteredDailyScheduleProvider>(
      FilteredScheduleProviderCreator.createFilteredDailyScheduleProvider(),
    );
    addSingle<FilteredBandScheduleProvider>(
      FilteredScheduleProviderCreator.createFilteredBandScheduleProvider(),
    );
    // Weather provider
    addSingle<WeatherProvider>(WeatherProviderCreator.create());
  }
}
