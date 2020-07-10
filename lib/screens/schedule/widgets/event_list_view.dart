import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/enhanced_event.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import '../../../widgets/first_build_mixin.dart';
import '../../band_detail_view/band_detail_view.dart';
import 'event_list_item.dart';

// TODO(SF) STYLE possible to use hook widget?
class EventListView extends StatefulWidget {
  const EventListView({
    Key key,
    this.events,
    this.date,
  }) : super(key: key);

  final ImmortalList<EnhancedEvent> events;
  final DateTime date;

  bool get isBandView => date == null;

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> with FirstBuildMixin {
  final _scrollController = ScrollController();

  int get _currentOrNextPlayingBandIndex {
    final now = DateTime.now();
    return widget.date != null && isSameFestivalDay(now, widget.date)
        ? widget.events.indexWhere((enhancedEvent) =>
            now.isBefore(enhancedEvent.event.start) ||
            now.isBefore(enhancedEvent.event.end))
        : -1;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventListView oldWidget) {
    if (mounted && !widget.isBandView && widget.events != oldWidget.events) {
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
    final items = widget.events.map<Widget>((enhancedEvent) => EventListItem(
          key: Key(enhancedEvent.event.id),
          enhancedEvent: enhancedEvent,
          isBandView: widget.isBandView,
          onTap: () => BandDetailView.openFor(context, enhancedEvent),
          isPlaying: enhancedEvent.event.isPlaying(now),
        ));
    if (_currentOrNextPlayingBandIndex >= 0 &&
        !widget.events[_currentOrNextPlayingBandIndex]
            .map((enhancedEvent) => enhancedEvent.event.isPlaying(now))
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
    onFirstBuild(() {
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
