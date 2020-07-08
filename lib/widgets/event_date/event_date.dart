import 'package:flutter/material.dart';

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
    final textStyle = Theme.of(context).textTheme.caption;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          (showWeekDay ? 'E HH:mm' : 'HH:mm').i18n.dateFormat(start),
          style: textStyle,
        ),
        Text(
          ' - ${'HH:mm'.i18n.dateFormat(end)}',
          style: showWeekDay
              ? textStyle
              : textStyle.copyWith(color: textStyle.color.withOpacity(.33)),
        ),
      ],
    );
  }
}
