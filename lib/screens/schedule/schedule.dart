import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../utils/date.dart';
import '../../utils/i18n.dart';
import '../../widgets/periodic_rebuild_mixin.dart';
import '../../widgets/scaffold.dart';
import 'schedule.i18n.dart';
import 'widgets/filtered_event_list.dart';
import 'widgets/weather_card.dart';

// TODO(SF) hook widget possible?
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({this.scheduledOnly = false});

  static Widget builder(BuildContext context) => ScheduleScreen();
  static Widget myScheduleBuilder(BuildContext context) =>
      ScheduleScreen(scheduledOnly: true);

  static String title() => 'Schedule'.i18n;
  static String myScheduleTitle() => 'My Schedule'.i18n;

  final bool scheduledOnly;

  @override
  State<StatefulWidget> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with WidgetsBindingObserver, PeriodicRebuildMixin<ScheduleScreen> {
  bool scheduledOnly = false;

  @override
  void initState() {
    super.initState();
    scheduledOnly = widget.scheduledOnly;
  }

  void _onScheduledFilterChange(bool newValue) {
    setState(() {
      scheduledOnly = newValue;
    });
  }

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  ImmortalList<DateTime> get _days => _config.days;

  int _initialTab() {
    final now = DateTime.now();
    return 1 + _days.indexWhere((day) => isSameFestivalDay(now, day));
  }

  TabBar _buildTabBar() => TabBar(
        tabs: [
          Tab(child: Text('Bands'.i18n)),
          ...List.generate(
            _days.length,
            (index) => Tab(
              child: Text('Day {number}'.i18n.fill({'number': index + 1})),
            ),
          ),
        ],
      );

  AppBar _buildAppBar() => AppBar(
        bottom: _theme.tabBarDecoration != null
            ? PreferredSize(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: _theme.tabBarHeight,
                      decoration: _theme.tabBarDecoration,
                    ),
                    _buildTabBar(),
                  ],
                ),
                preferredSize: Size.fromHeight(_theme.tabBarHeight),
              )
            : _buildTabBar(),
        title: _theme.logo != null
            ? Image.asset(
                _theme.logo.assetPath,
                width: _theme.logo.width,
                height: _theme.logo.height,
              )
            : Text(_config.festivalName),
        actions: <Widget>[
          Icon(scheduledOnly ? Icons.star : Icons.star_border),
          Switch(
            value: scheduledOnly,
            onChanged: _onScheduledFilterChange,
          ),
        ],
      );

  Widget _buildEventList(BuildContext context, {DateTime date}) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (date != null) WeatherCard(date),
          FilteredEventList(
            date: date,
            scheduledOnly: scheduledOnly,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: _days.length + 1,
        initialIndex: _initialTab(),
        child: AppScaffold(
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              _buildEventList(context),
              ..._days
                  .map((date) => _buildEventList(context, date: date))
                  .toMutableList(),
            ],
          ),
        ),
      );
}
