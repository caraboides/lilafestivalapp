import 'dart:math';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

import '../../../models/enhanced_event.dart';
import '../../../models/theme.dart';
import '../../../utils/date.dart';
import '../../../widgets/first_build_mixin.dart';
import 'event_list_item.dart';

// TODO(SF) possible to use hook widget?
class EventListView extends StatefulWidget {
  const EventListView({
    Key key,
    this.events,
    this.date,
    this.openBandDetails,
  }) : super(key: key);

  final ImmortalList<EnhancedEvent> events;
  final DateTime date;
  final ValueChanged<EnhancedEvent> openBandDetails;

  bool get isBandView => date == null;

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> with FirstBuildMixin {
  final _scrollController = ScrollController();

  int get currentOrNextPlayingBandIndex {
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

  void _scrollToCurrentBand({
    Duration timeout = const Duration(milliseconds: 50),
  }) {
    Future.delayed(timeout, () {
      if (mounted) {
        if (currentOrNextPlayingBandIndex >= 0) {
          _scrollController.animateTo(
            max(currentOrNextPlayingBandIndex - 2, 0) *
                dimeGet<FestivalTheme>().eventListItemHeight,
            duration: Duration(milliseconds: 500),
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
          onTap: () => widget.openBandDetails(enhancedEvent),
          isPlaying: enhancedEvent.event.isPlaying(now),
        ));
    if (currentOrNextPlayingBandIndex >= 0 &&
        !widget.events[currentOrNextPlayingBandIndex]
            .map((enhancedEvent) => enhancedEvent.event.isPlaying(now))
            .orElse(false)) {
      return items.insert(
          currentOrNextPlayingBandIndex,
          Container(
            key: Key('change-over'),
            height: 2,
            color: Theme.of(context).accentColor,
          ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    onFirstBuild(() {
      _scrollToCurrentBand(timeout: Duration(milliseconds: 200));
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
