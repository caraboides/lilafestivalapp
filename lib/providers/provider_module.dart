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
    addSingle<BandsProvider>(BandsProvider(context));
    addSingle<BandProvider>(BandProvider());
    addSingle<SortedBandsProvider>(SortedBandsProvider());
    // Schedule providers
    addSingle<ScheduleProvider>(ScheduleProvider(context));
    addSingle<FestivalDaysProvider>(FestivalDaysProvider());
    addSingle<SortedScheduleProvider>(SortedScheduleProvider());
    addSingle<DailyScheduleProvider>(DailyScheduleProvider());
    addSingle<DailyScheduleMapProvider>(DailyScheduleMapProvider());
    addSingle<BandScheduleProvider>(BandScheduleProvider());
    // My Schedule providers
    addSingle<MyScheduleProvider>(MyScheduleProvider());
    addSingle<LikedEventProvider>(LikedEventProvider());
    // Combined bands and events providers
    addSingle<BandWithEventsProvider>(BandWithEventsProvider());
    addSingle<BandsWithEventsProvider>(BandsWithEventsProvider());
    // Filtered band and event providers
    addSingle<FilteredDailyScheduleProvider>(FilteredDailyScheduleProvider());
    addSingle<FilteredBandScheduleProvider>(FilteredBandScheduleProvider());
    // Weather provider
    addSingle<WeatherProvider>(WeatherProvider());
  }
}
