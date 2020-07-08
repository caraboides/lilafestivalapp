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

// TODO(SF) hook widget possible?
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({this.scheduledOnly = false});

  static Widget builder(BuildContext context) => ScheduleScreen();
  static Widget myScheduleBuilder(BuildContext context) =>
      ScheduleScreen(scheduledOnly: true);

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

  ImmortalList<DateTime> get _days => dimeGet<FestivalConfig>().days;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  int _initialTab() {
    final now = DateTime.now();
    return 1 + _days.indexWhere((day) => isSameFestivalDay(now, day));
  }

  Tab _buildTab(String title) =>
      Tab(child: Text(title, style: _theme.tabTextStyle));

  AppBar _buildAppBar() => AppBar(
        bottom: TabBar(
          tabs: [
            _buildTab('Bands'.i18n),
            ...List.generate(
              _days.length,
              (index) =>
                  _buildTab('Day {number}'.i18n.fill({'number': index + 1})),
            ),
          ],
        ),
        // title: Image.asset(
        //   'assets/logo.png',
        //   width: 158,
        //   height: 40,
        // ),
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
          // if (date != null) WeatherWidget(date),
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
