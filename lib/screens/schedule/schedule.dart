import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/festival_config.dart';
import '../../providers/festival_scope.dart';
import '../../services/navigation.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import '../../widgets/mixins/periodic_rebuild_mixin.dart';
import 'schedule.i18n.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({this.likedOnly = false});

  static Widget builder(BuildContext context) => const ScheduleScreen();
  static Widget myScheduleBuilder(BuildContext context) =>
      const ScheduleScreen(likedOnly: true);

  static String mySchedulePath = '/mySchedule';
  static String path = '/';

  static String title() => 'Schedule'.i18n;
  static String myScheduleTitle() => 'My Schedule'.i18n;

  final bool likedOnly;

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

// TODO(SF): STYLE create hook for periodic rebuild?
class _ScheduleScreenState extends State<ScheduleScreen>
    with
        WidgetsBindingObserver,
        PeriodicRebuildMixin<ScheduleScreen>,
        RouteAware {
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Navigation get _navigation => dimeGet<Navigation>();

  void onLikedFilterChange({bool likedOnly = false}) {
    _navigation.routeObserver.replaceCurrentRoute(
      likedOnly ? ScheduleScreen.mySchedulePath : ScheduleScreen.path,
    );
  }

  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
    scopeName: FestivalScope.scopeName,
    modules: <BaseDimeModule>[
      FestivalScopeModule(_config.currentFestivalScope),
    ],
    child: FullSchedule(
      likedOnly: widget.likedOnly,
      displayWeather: true,
      onLikedFilterChange: onLikedFilterChange,
    ),
  );
}
