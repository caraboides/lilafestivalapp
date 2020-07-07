import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';

import '../../../models/festival_config.dart';
import '../../../models/scheduled_event.dart';
import '../../../models/theme.dart';
import '../../../providers/combined_schedule.dart';
import '../../../utils/date.dart';
import 'event_list_item.dart';
import 'event_list_view.i18n.dart';

// TODO(SF) possible to use hook widget?
class EventListView extends StatefulWidget {
  const EventListView({
    Key key,
    this.scheduleFilterTag,
    this.date,
    this.openEventDetails,
    this.favoritesOnly,
  }) : super(key: key);

  final String scheduleFilterTag;
  final DateTime date;
  final ValueChanged<ScheduledEvent> openEventDetails;
  final bool favoritesOnly;

  bool get bandView => date == null;

  @override
  State<StatefulWidget> createState() => EventListViewState();
}

class EventListViewState extends State<EventListView> {
  final _scrollController = ScrollController();
  bool _firstBuild = true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EventListView oldWidget) {
    if (mounted &&
        !widget.bandView &&
        widget.favoritesOnly != oldWidget.favoritesOnly) {
      // _scrollToCurrentBand();
    }
    super.didUpdateWidget(oldWidget);
  }

  // void _scrollToCurrentBand(
  //     {Duration timeout = const Duration(milliseconds: 50)}) {
  //   Future.delayed(timeout, () {
  //     if (mounted) {
  //       final now = DateTime.now();
  //       final index = getEvents(MyScheduleController.of(context)).indexWhere(
  //           (event) => now.isBefore(event.start) || now.isBefore(event.end));
  //       if (index >= 0) {
  //         _scrollController.animateTo(
  //           max(index - 2, 0) * dimeGet<FestivalTheme>().eventListItemHeight,
  //           duration: Duration(milliseconds: 500),
  //           curve: Curves.easeIn,
  //         );
  //       }
  //     }
  //   });
  // }

  Widget _buildEventList(ImmortalList<ScheduledEvent> events) {
    final now = DateTime.now();
    final config = dimeGet<FestivalConfig>();
    final theme = dimeGet<FestivalTheme>();
    final nextOrCurrentIndex = widget.date != null &&
            isSameDay(now, widget.date, offset: config.daySwitchOffset)
        ? events.indexWhere((scheduledEvent) =>
            now.isBefore(scheduledEvent.event.start) ||
            now.isBefore(scheduledEvent.event.end))
        : -1;
    var currentlyPlaying = false;
    var items = events.map<Widget>((scheduledEvent) {
      final isPlaying = !now.isBefore(scheduledEvent.event.start) &&
          !now.isAfter(scheduledEvent.event.end);
      currentlyPlaying = currentlyPlaying || isPlaying;
      return EventListItem(
        key: Key(scheduledEvent.event.id),
        event: scheduledEvent,
        bandView: widget.bandView,
        openEventDetails: () => widget.openEventDetails(scheduledEvent),
        isPlaying: isPlaying,
      );
    });
    if (nextOrCurrentIndex >= 0 && !currentlyPlaying) {
      items = items.insert(
          nextOrCurrentIndex,
          Container(
            height: 2,
            color: theme.theme.accentColor,
          ));
    }
    if (widget.favoritesOnly && items.isEmpty) {
      return Expanded(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Don't you like music?".i18n),
            ),
            Icon(Icons.star_border),
            Padding(
              padding: EdgeInsets.all(20),
              child:
                  Text('You did not add any gigs to your schedule yet!'.i18n),
            ),
          ],
        ),
      );
    }
    if (_firstBuild && !widget.bandView) {
      _firstBuild = false;
      // _scrollToCurrentBand(timeout: Duration(milliseconds: 200));
    }
    return Expanded(
      child: ListView(
        controller: _scrollController,
        children: ListTile.divideTiles(
          context: context,
          tiles: items.toMutableList(),
        ).toList(),
      ),
    );
  }

  // TODO(SF) use computed as well?
  ImmortalList<ScheduledEvent> _filterEvents(
          ImmortalList<ScheduledEvent> events) =>
      !widget.favoritesOnly ? events : events.filter((event) => event.isLiked);

  @override
  Widget build(BuildContext context) => Consumer((context, read) {
        final events = read(
            dimeGet<CombinedScheduleProvider>(tag: widget.scheduleFilterTag));
        return events.when(
          data: (events) => _buildEventList(_filterEvents(events)),
          // TODO(SF)
          loading: () => Center(child: Text('Loading!')),
          error: (e, trace) => Center(
            child: Text('Error! $e ${trace.toString()}'),
          ),
        );
      });
}
