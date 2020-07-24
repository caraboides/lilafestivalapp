import 'package:dime/dime.dart';
import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../models/festival_config.dart';
import '../../models/theme.dart';
import '../../providers/festival_scope.dart';
import '../../providers/schedule.dart';
import '../../utils/date.dart';
import '../../utils/i18n.dart';
import '../../utils/logging.dart';
import '../messages/error_screen/error_screen.dart';
import '../messages/loading_screen/loading_screen.dart';
import '../scaffold.dart';
import 'full_schedule.i18n.dart';
import 'widgets/band_schedule_list/band_schedule_list.dart';
import 'widgets/daily_schedule_list/daily_schedule_list.dart';
import 'widgets/weather_card.dart';

class FullSchedule extends StatefulHookWidget {
  const FullSchedule({
    this.likedOnly = false,
    this.displayWeather = false,
  });

  final bool likedOnly;
  final bool displayWeather;

  @override
  State<StatefulWidget> createState() => _FullScheduleState();
}

class _FullScheduleState extends State<FullSchedule> {
  bool _likedOnly = false;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();
  Logger get _log => const Logger(module: 'FullSchedule');

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

  int _initialTab(ImmortalList<DateTime> days) {
    final now = DateTime.now();
    return 1 + days.indexWhere((day) => isSameFestivalDay(now, day));
  }

  TabBar _buildTabBar(ImmortalList<DateTime> days) => TabBar(
        tabs: [
          Tab(child: Text('Bands'.i18n)),
          ...days
              .mapIndexed((index, date) => Tooltip(
                  message: 'MMM dd'.i18n.dateFormat(date),
                  child: Tab(
                      child: Text(
                    'Day {number}'.i18n.fill({'number': index + 1}),
                  ))))
              .toMutableList(),
        ],
      );

  Widget _buildTitleWidget(FestivalScope festivalScope) {
    if (festivalScope.isCurrentFestival) {
      return _theme.logo != null
          ? Image.asset(
              _theme.logo.assetPath,
              width: _theme.logo.width,
              height: _theme.logo.height,
            )
          : Text(_config.festivalName);
    }
    return Text(_config.festivalName + festivalScope.titleSuffix);
  }

  Widget _buildTabBarContainer(ImmortalList<DateTime> days) =>
      _theme.tabBarDecoration != null
          ? PreferredSize(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: _theme.tabBarHeight,
                    decoration: _theme.tabBarDecoration,
                  ),
                  _buildTabBar(days),
                ],
              ),
              preferredSize: Size.fromHeight(_theme.tabBarHeight),
            )
          : _buildTabBar(days);

  AppBar _buildAppBar(
    ImmortalList<DateTime> days,
    FestivalScope festivalScope,
  ) =>
      AppBar(
        bottom: days != null ? _buildTabBarContainer(days) : null,
        title: _buildTitleWidget(festivalScope),
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

  Widget _buildBandScheduleList() => BandScheduleList(likedOnly: _likedOnly);

  Widget _buildDailyScheduleList(DateTime date) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (widget.displayWeather) WeatherCard(date),
          Expanded(
            child: DailyScheduleList(date, likedOnly: _likedOnly),
          ),
        ],
      );

  Widget _buildScaffold({
    Widget child,
    FestivalScope festivalScope,
    ImmortalList<DateTime> days,
  }) =>
      AppScaffold(
        appBar: _buildAppBar(days, festivalScope),
        body: child,
      );

  Widget _buildScheduleView(
    ImmortalList<DateTime> days,
    FestivalScope festivalScope,
  ) =>
      DefaultTabController(
          length: days.length + 1,
          initialIndex: _initialTab(days),
          child: _buildScaffold(
            days: days,
            festivalScope: festivalScope,
            child: TabBarView(
              children: [
                _buildBandScheduleList(),
                ...days.map(_buildDailyScheduleList).toMutableList(),
              ],
            ),
          ));

  @override
  Widget build(BuildContext context) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    final provider =
        useProvider(dimeGet<FestivalDaysProvider>()(festivalScope.festivalId));
    return provider.when(
      data: (days) => _buildScheduleView(days, festivalScope),
      loading: () => _buildScaffold(
        festivalScope: festivalScope,
        child: LoadingScreen('Loading schedule.'.i18n),
      ),
      error: (error, trace) {
        _log.error(
            'Error retrieving festival days for ${festivalScope.festivalId}',
            error,
            trace);
        return _buildScaffold(
          festivalScope: festivalScope,
          child:
              ErrorScreen('There was an error retrieving the schedule.'.i18n),
        );
      },
    );
  }
}
