import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

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

class FullSchedule extends StatefulHookConsumerWidget {
  const FullSchedule({
    this.likedOnly = false,
    this.displayWeather = false,
    this.onLikedFilterChange,
  });

  final bool likedOnly;
  final bool displayWeather;
  final Function({bool likedOnly})? onLikedFilterChange;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FullScheduleState();
}

class _FullScheduleState extends ConsumerState<FullSchedule> {
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
    widget.onLikedFilterChange?.call(likedOnly: newValue);
  }

  int _initialTab(ImmortalList<DateTime> days) {
    final now = currentDate();
    return 1 + days.indexWhere((day) => isSameFestivalDay(now, day));
  }

  TabBar _buildTabBar(ImmortalList<DateTime> days) => TabBar(
    indicatorWeight: 2,
    indicatorColor: _theme.theme.colorScheme.secondary,
    tabs: [
      Tab(child: Text('Bands'.i18n)),
      ...days.mapIndexed(
        (index, date) => Tooltip(
          message: 'MMM dd'.i18n.dateFormat(date),
          child: Tab(
            child: Text('Day {number}'.i18n.fill({'number': index + 1})),
          ),
        ),
      ),
    ],
  );

  Widget _buildTitleWidget(FestivalScope festivalScope) {
    if (festivalScope is HistoryFestivalScope) {
      return Text(_config.festivalName + festivalScope.titleSuffix);
    }
    return _theme.logo?.toAsset() ?? Text(_config.festivalName);
  }

  PreferredSizeWidget _buildTabBarContainer(ImmortalList<DateTime> days) =>
      _theme.tabBarDecoration != null
      ? PreferredSize(
          preferredSize: Size.fromHeight(_theme.tabBarHeight),
          child: Stack(
            children: <Widget>[
              Container(
                height: _theme.tabBarHeight,
                decoration: _theme.tabBarDecoration,
              ),
              _buildTabBar(days),
            ],
          ),
        )
      : _buildTabBar(days);

  List<Widget> _buildActions() => [
    Tooltip(
      message:
          (_likedOnly ? 'Show full schedule' : 'Show my schedule only').i18n,
      child: Switch(
        value: _likedOnly,
        onChanged: _onLikedFilterChange,
        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) => Icon(
            states.contains(WidgetState.selected)
                ? Icons.star
                : Icons.star_border,
            color: _theme.theme.colorScheme.surface,
          ),
        ),
      ),
    ),
    const SizedBox(width: 8),
  ];

  AppBar _buildAppBar(
    ImmortalList<DateTime>? days,
    FestivalScope festivalScope,
  ) => AppBar(
    bottom: Optional.ofNullable(days).map(_buildTabBarContainer).orElseNull,
    title: _buildTitleWidget(festivalScope),
    actions: _buildActions(),
  );

  Widget _buildBandScheduleList() => BandScheduleList(likedOnly: _likedOnly);

  Widget _buildDailyScheduleList(DateTime date) => Column(
    mainAxisSize: MainAxisSize.max,
    children: <Widget>[
      Visibility(visible: widget.displayWeather, child: WeatherCard(date)),
      Expanded(child: DailyScheduleList(date, likedOnly: _likedOnly)),
    ],
  );

  Widget _buildScaffold({
    required Widget child,
    required FestivalScope festivalScope,
    ImmortalList<DateTime>? days,
  }) => AppScaffold.withAppBar(
    appBar: _buildAppBar(days, festivalScope),
    body: child,
  );

  Widget _buildScheduleView(
    ImmortalList<DateTime> days,
    FestivalScope festivalScope,
  ) => DefaultTabController(
    length: days.length + 1,
    initialIndex: _initialTab(days),
    child: _buildScaffold(
      days: days,
      festivalScope: festivalScope,
      child: TabBarView(
        children: [
          _buildBandScheduleList(),
          ...days.map(_buildDailyScheduleList),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    final provider = ref.watch(
      dimeGet<FestivalDaysProvider>()(festivalScope.festivalId),
    );
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
          trace,
        );
        return _buildScaffold(
          festivalScope: festivalScope,
          child: ErrorScreen(
            'There was an error retrieving the schedule.'.i18n,
          ),
        );
      },
    );
  }
}
