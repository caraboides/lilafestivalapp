import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../models/event.dart';
import '../../models/festival_config.dart';
import 'event_band_name.dart';
import 'event_date/event_date.dart';
import 'event_stage.dart';
import 'event_venue.dart';

class EventDetails extends StatelessWidget {
  const EventDetails(
    this.event, {
    super.key,
    this.showBandName = false,
    this.showWeekDay = false,
    this.alignByStage = false,
  });

  final Event event;
  final bool showBandName;
  final bool showWeekDay;
  final bool alignByStage;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment:
        alignByStage
            ? dimeGet<FestivalConfig>().stageAlignment(event.stage)
            : CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Visibility(visible: showBandName, child: EventBandName(event.bandName)),
      Visibility(visible: showBandName, child: const SizedBox(height: 3.5)),
      EventDate(start: event.start, end: event.end, showWeekDay: showWeekDay),
      const SizedBox(height: 2.5),
      EventVenue(event.venueName),
      const SizedBox(height: 2.5),
      EventStage(event.stage)
    ],
  );
}
