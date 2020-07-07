import 'package:dime/dime.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/theme.dart';
import '../../utils/i18n.dart';
import 'event_date.i18n.dart';

class EventDate extends StatelessWidget {
  const EventDate({
    this.start,
    this.end,
    this.showWeekDay = false,
  });

  final DateTime start;
  final DateTime end;
  final bool showWeekDay;

  @override
  Widget build(BuildContext context) {
    final theme = dimeGet<FestivalTheme>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          (showWeekDay ? 'E HH:mm' : 'HH:mm').i18n.dateFormat(start),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.eventDateTextStyle,
        ),
        Text(
          ' - ${'HH:mm'.i18n.dateFormat(end)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: showWeekDay
              ? theme.eventDateTextStyle
              : theme.eventDateTextStyle
                  .copyWith(color: Colors.black.withOpacity(0.33)),
        ),
      ],
    );
  }
}

/*
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      '${'E HH:mm'.i18n.dateFormat(event.start)} - '
                      '${'HH:mm'.i18n.dateFormat(event.end)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.eventDateTextStyle,
                    ),
                  ),

 */
