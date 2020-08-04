import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import '../../mixins/one_time_execution_mixin.dart';
import 'divided_list_tile.dart';
import 'event_list_item.dart';

class EventListView extends StatefulWidget {
  const EventListView({
    @required this.events,
    @required this.date,
    Key key,
  }) : super(key: key);

  final ImmortalList<Event> events;
  final DateTime date;

  @override
  State<StatefulWidget> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView>
    with OneTimeExecutionMixin {
  final _scrollController = ScrollController();

  int get _currentOrNextPlayingBandIndex {
    final now = DateTime.now();
    return isSameFestivalDay(now, widget.date)
        ? widget.events.indexWhere((event) => event.isPlayingOrInFutureOf(now))
        : -1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventListView oldWidget) {
    if (mounted && widget.events != oldWidget.events) {
      _scrollToCurrentBand();
    }
    super.didUpdateWidget(oldWidget);
  }

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  void _scrollToCurrentBand({
    Duration timeout = const Duration(milliseconds: 50),
  }) {
    Future.delayed(timeout, () {
      if (mounted) {
        if (_currentOrNextPlayingBandIndex >= 0) {
          _scrollController.animateTo(
            max(_currentOrNextPlayingBandIndex - 2, 0) *
                _theme.eventListItemHeight,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        }
      }
    });
  }

  Widget _buildEventListItem(DateTime now, Event event) => EventListItem(
        event: event,
        key: Key(event.id),
        isPlaying: event.isPlaying(now),
      );

  Widget _buildCurrentOrNextListItem(DateTime now, Event event) => Column(
        children: <Widget>[
          Visibility(
            visible: !event.isPlaying(now),
            child: DividedListTile(
              child: Container(
                key: const Key('change-over'),
                height: 2,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          _buildEventListItem(now, event),
        ],
      );

  Widget _buildListItem(DateTime now, int index) => widget.events[index]
      .map((event) => _currentOrNextPlayingBandIndex >= 0 &&
              _currentOrNextPlayingBandIndex == index
          ? _buildCurrentOrNextListItem(now, event)
          : _buildEventListItem(now, event))
      .orElse(Container());

  @override
  Widget build(BuildContext context) {
    executeOnce(() {
      _scrollToCurrentBand(timeout: const Duration(milliseconds: 200));
    });
    final now = DateTime.now();
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.events.length,
      itemBuilder: (context, index) => DividedListTile(
        isLast: index == widget.events.length - 1,
        child: _buildListItem(now, index),
      ),
    );
  }
}
