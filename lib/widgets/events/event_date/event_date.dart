import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../../utils/i18n.dart';
import 'event_date.i18n.dart';

class EventDate extends StatelessWidget {
  const EventDate({
    @required this.start,
    @required this.end,
    this.showWeekDay = false,
  });

  final Optional<DateTime> start;
  final Optional<DateTime> end;
  final bool showWeekDay;

  List<Widget> _buildTimes(BuildContext context) {
    if (!start.isPresent) {
      return <Widget>[];
    }
    final textStyle = Theme.of(context).textTheme.caption;
    return <Widget>[
      Text(
        (showWeekDay ? 'E HH:mm' : 'HH:mm').i18n.dateFormat(start.value),
        style: textStyle,
      ),
      if (end.isPresent)
        Text(
          ' - ${'HH:mm'.i18n.dateFormat(end.value)}',
          style: showWeekDay
              ? textStyle
              : textStyle.copyWith(color: textStyle.color.withOpacity(.33)),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: _buildTimes(context),
      );
}
