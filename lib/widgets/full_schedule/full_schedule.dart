import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../models/theme.dart';
import '../../utils/date.dart';
import '../../utils/i18n.dart';
import '../scaffold.dart';
import '../weather_card.dart';
import 'full_schedule.i18n.dart';
import 'widgets/band_schedule_list/band_schedule_list.dart';
import 'widgets/daily_schedule_list/daily_schedule_list.dart';

class FullSchedule extends StatefulWidget {
  const FullSchedule({
    @required this.festivalId,
    @required this.titleWidget,
    @required this.days,
    this.likedOnly = false,
    this.displayWeather = false,
  });

  final String festivalId;
  final Widget titleWidget;
  final ImmortalList<DateTime> days;
  final bool likedOnly;
  final bool displayWeather;

  @override
  State<StatefulWidget> createState() => _FullScheduleState();
}

// TODO(SF) STYLE HISTORY possible to use hookwidget?
class _FullScheduleState extends State<FullSchedule> {
  bool _likedOnly = false;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  void initState() {
    super.initState();
    _likedOnly = widget.likedOnly;
  }

  void _onLikedFilterChange(bool newValue) {
    setState(() {
      _likedOnly = newValue;
    });
  }

  int _initialTab() {
    final now = DateTime.now();
    return 1 + widget.days.indexWhere((day) => isSameFestivalDay(now, day));
  }

  TabBar _buildTabBar() => TabBar(
        tabs: [
          Tab(child: Text('Bands'.i18n)),
          ...List.generate(
            widget.days.length,
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
        title: widget.titleWidget,
        actions: <Widget>[
          Icon(_likedOnly ? Icons.star : Icons.star_border),
          Tooltip(
            message:
                (_likedOnly ? 'Show full schedule' : 'Show my schedule only')
                    .i18n,
            child: Switch(
              value: _likedOnly,
              onChanged: _onLikedFilterChange,
            ),
          ),
        ],
      );

  Widget _buildBandScheduleList() => BandScheduleList(
        festivalId: widget.festivalId,
        likedOnly: _likedOnly,
      );

  Widget _buildDailyScheduleList(DateTime date) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (widget.displayWeather) WeatherCard(date),
          Expanded(
            child: DailyScheduleList(
              date,
              festivalId: widget.festivalId,
              likedOnly: _likedOnly,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: widget.days.length + 1,
        initialIndex: _initialTab(),
        child: AppScaffold(
          appBar: _buildAppBar(),
          body: TabBarView(
            children: [
              _buildBandScheduleList(),
              ...widget.days.map(_buildDailyScheduleList).toMutableList(),
            ],
          ),
        ),
      );
}
