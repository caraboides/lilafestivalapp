import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../models/festival_config.dart';
import 'event_band_name.dart';
import 'event_date/event_date.dart';
import 'event_stage.dart';

class EventDetails extends StatelessWidget {
  const EventDetails(
    this.event, {
    Key key,
    this.showBandName = false,
    this.showWeekDay = false,
    this.alignByStage = false,
  }) : super(key: key);

  final Event event;
  final bool showBandName;
  final bool showWeekDay;
  final bool alignByStage;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: alignByStage
            ? dimeGet<FestivalConfig>().stageAlignment(event.stage)
            : CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (showBandName) EventBandName(event.bandName),
          if (showBandName) const SizedBox(height: 3.5),
          EventDate(
            start: event.start,
            end: event.end,
            showWeekDay: showWeekDay,
          ),
          const SizedBox(height: 2.5),
          EventStage(event.stage),
        ],
      );
}
