import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models/config.dart';
import '../models/theme.dart';
import '../utils/date.dart';
import '../widgets/periodic_rebuild_mixin.dart';

// TODO(SF) hook widget possible?
class HomeScreen extends StatefulWidget {
  const HomeScreen({this.favoritesOnly = false});

  final bool favoritesOnly;

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

// TODO(SF) test mixin
class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, PeriodicRebuildMixin<HomeScreen> {
  bool favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    favoritesOnly = widget.favoritesOnly;
  }

  void _onFavoritesFilterChange(bool newValue) {
    setState(() {
      favoritesOnly = newValue;
    });
  }

  // void _openEventDetails(BuildContext context, Event event) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //     builder: (_) => EventDetailView(event),
  //     fullscreenDialog: true,
  //   ));
  // }

  Widget _buildEventList(BuildContext context, {DateTime date}) => Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // if (date != null) WeatherWidget(date),
          // EventListView(
          //   eventFilter:
          //       date != null ? Schedule.dayOf(date) : Schedule.allBandsOf,
          //   date: date,
          //   openEventDetails: (event) => _openEventDetails(context, event),
          //   favoritesOnly: favoritesOnly,
          // ),
        ],
      );

  int _initialTab(FestivalConfig config) {
    final now = DateTime.now();
    return config.days.indexWhere(
          (day) => isSameDay(now, day, offset: config.daySwitchOffset),
        ) +
        1;
  }

  @override
  Widget build(BuildContext context) {
    final config = dimeGet<FestivalConfig>();
    final theme = dimeGet<FestivalTheme>();
    return DefaultTabController(
      length: config.days.length + 1,
      initialIndex: _initialTab(config),
      child: Scaffold(
        // drawer: const Menu(),
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Bands'.i18n,
                  style: theme.tabTextStyle,
                ),
              ),
              ...List.generate(
                config.days.length,
                (index) => Tab(
                  child: Text(
                    'Day %d'.i18n.fill(index + 1),
                    style: theme.tabTextStyle,
                  ),
                ),
              ),
            ],
          ),
          // title: Image.asset(
          //   'assets/logo.png',
          //   width: 158,
          //   height: 40,
          // ),
          actions: <Widget>[
            Icon(favoritesOnly ? Icons.star : Icons.star_border),
            Switch(
              value: favoritesOnly,
              onChanged: _onFavoritesFilterChange,
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildEventList(context),
            ...config.days
                .map((date) => _buildEventList(context, date: date))
                .toMutableList(),
          ],
        ),
      ),
    );
  }
}
