import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import '../../../widgets/one_time_execution_mixin.dart';
import 'event_list_item.dart';

// TODO(SF) STYLE possible to use hook widget?
class EventListView extends StatefulWidget {
  const EventListView({
    Key key,
    this.events,
    this.date,
  }) : super(key: key);

  final ImmortalList<Event> events;
  final DateTime date;

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView>
    with OneTimeExecutionMixin {
  final _scrollController = ScrollController();

  int get _currentOrNextPlayingBandIndex {
    final now = DateTime.now();
    return isSameFestivalDay(now, widget.date)
        ? widget.events.indexWhere((event) =>
            event.start.map(now.isBefore).orElse(false) ||
            event.end.map(now.isBefore).orElse(false))
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

  ImmortalList<Widget> _buildListItems() {
    final now = DateTime.now();
    final items = widget.events.map<Widget>((event) => EventListItem(
          key: Key(event.id),
          event: event,
          isPlaying: event.isPlaying(now),
        ));
    if (_currentOrNextPlayingBandIndex >= 0 &&
        !widget.events[_currentOrNextPlayingBandIndex]
            .map((event) => event.isPlaying(now))
            .orElse(false)) {
      return items.insert(
          _currentOrNextPlayingBandIndex,
          Container(
            key: const Key('change-over'),
            height: 2,
            color: Theme.of(context).accentColor,
          ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    executeOnce(() {
      _scrollToCurrentBand(timeout: const Duration(milliseconds: 200));
    });
    return Expanded(
      child: ListView(
        controller: _scrollController,
        children: ListTile.divideTiles(
          context: context,
          tiles: _buildListItems().toMutableList(),
        ).toList(),
      ),
    );
  }
}
