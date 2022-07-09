import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../../../models/event.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import '../../mixins/one_time_execution_mixin.dart';
import 'animated_list_view.dart';
import 'divided_list_tile.dart';
import 'event_list_item.dart';

class EventListView extends StatefulWidget {
  const EventListView({
    required this.events,
    required this.eventIds,
    required this.date,
    Key? key,
  }) : super(key: key);

  final ImmortalMap<String, Event> events;
  final ImmortalList<String> eventIds;
  final DateTime date;

  @override
  State<StatefulWidget> createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView>
    with OneTimeExecutionMixin {
  final _scrollController = ScrollController();
  late DateTime _currentTime;
  int _currentOrNextPlayingBandIndex = -1;
  int _nextPlayingBandIndex = -1;
  late ImmortalList<String> _itemIds;

  static const String _changeOverId = 'change-over';

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  int get _numItems =>
      widget.events.length + (_nextPlayingBandIndex >= 0 ? 1 : 0);

  Optional<Event> _eventAt(int index) => widget.eventIds[index]
      .map((eventId) => widget.events[eventId])
      .orElse(const Optional<Event>.empty());

  void _updateCurrentDate() {
    _currentTime = DateTime.now();
  }

  void _updatePlayingBandIndices() {
    _currentOrNextPlayingBandIndex =
        isSameFestivalDay(_currentTime, widget.date)
            ? widget.eventIds.indexWhere((eventId) => widget.events[eventId]
                .map((event) => event.isPlayingOrInFutureOf(_currentTime))
                .orElse(false))
            : -1;
    _nextPlayingBandIndex = _currentOrNextPlayingBandIndex >= 0 &&
            _eventAt(_currentOrNextPlayingBandIndex)
                .map((event) => !event.isPlaying(_currentTime))
                .orElse(false)
        ? _currentOrNextPlayingBandIndex
        : -1;
  }

  void _updateItemIds() {
    _itemIds = _nextPlayingBandIndex >= 0
        ? widget.eventIds.insert(_nextPlayingBandIndex, _changeOverId)
        : widget.eventIds;
  }

  @override
  void initState() {
    _updateCurrentDate();
    _updatePlayingBandIndices();
    _updateItemIds();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventListView oldWidget) {
    _updateCurrentDate();
    if (mounted && widget.eventIds != oldWidget.eventIds) {
      _updatePlayingBandIndices();
      _updateItemIds();
      _scrollToCurrentBand();
    }
    super.didUpdateWidget(oldWidget);
  }

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

  Widget _buildEventListItem(int index, Event event) => DividedListTile(
        key: Key(event.id),
        isLast: index == _numItems - 1,
        child: EventListItem(
          event: event,
          isPlaying: event.isPlaying(_currentTime),
        ),
      );

  Widget _buildChangeOverIndicator() => DividedListTile(
        key: const Key(_changeOverId),
        child: Container(
          height: 2,
          color: Theme.of(context).accentColor,
        ),
      );

  Widget _buildListItem({
    required BuildContext context,
    required Animation<double> animation,
    required int index,
    required String itemId,
  }) =>
      itemId == _changeOverId
          ? _buildChangeOverIndicator()
          : widget.events[itemId]
              .map((event) => _buildEventListItem(index, event))
              .orElse(Container());

  @override
  Widget build(BuildContext context) {
    executeOnce(() {
      _scrollToCurrentBand(timeout: const Duration(milliseconds: 200));
    });
    return AnimatedListView(
      scrollController: _scrollController,
      initialItemCount: _numItems,
      itemBuilder: _buildListItem,
      itemIds: _itemIds,
    );
  }
}
