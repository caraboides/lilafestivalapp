import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../../models/festival_config.dart';
import '../../../widgets/event_date/event_date.dart';
import '../../../widgets/event_stage.dart';
import 'event_band_name.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({
    Key key,
    this.event,
    this.isBandView = false,
  }) : super(key: key);

  final Event event;
  final bool isBandView;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: isBandView
            ? CrossAxisAlignment.start
            : dimeGet<FestivalConfig>().stageAlignment(event.stage),
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          EventBandName(event.bandName),
          const SizedBox(height: 3.5),
          EventDate(
            start: event.start,
            end: event.end,
            showWeekDay: isBandView,
          ),
          const SizedBox(height: 2.5),
          EventStage(event.stage),
        ],
      );
}
