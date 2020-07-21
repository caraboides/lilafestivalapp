import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../providers/festival_scope.dart';
import '../../widgets/full_schedule/full_schedule.dart';
import '../../widgets/periodic_rebuild_mixin.dart';
import 'schedule.i18n.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({this.likedOnly = false});

  static Widget builder(BuildContext context) => const ScheduleScreen();
  static Widget myScheduleBuilder(BuildContext context) =>
      const ScheduleScreen(likedOnly: true);

  static String title() => 'Schedule'.i18n;
  static String myScheduleTitle() => 'My Schedule'.i18n;

  final bool likedOnly;

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

// TODO(SF) STYLE create hook four periodic rebuild?
class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver, PeriodicRebuildMixin<ScheduleScreen> {
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  Widget _buildTitleWidget() => _theme.logo != null
      ? Image.asset(
          _theme.logo.assetPath,
          width: _theme.logo.width,
          height: _theme.logo.height,
        )
      : Text(_config.festivalName);

  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
        modules: <BaseDimeModule>[FestivalScopeModule(_config.festivalId)],
        child: FullSchedule(
          titleWidget: _buildTitleWidget(),
          days: _config.days,
          likedOnly: widget.likedOnly,
          displayWeather: true,
        ),
      );
}
