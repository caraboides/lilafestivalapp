import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../../utils/i18n.dart';
import '../../optional_builder.dart';
import 'event_date.i18n.dart';

class EventDate extends StatelessWidget {
  const EventDate({
    required this.start,
    required this.end,
    this.showWeekDay = false,
  });

  final Optional<DateTime> start;
  final Optional<DateTime> end;
  final bool showWeekDay;

  List<Widget> _buildTimes(BuildContext context, DateTime startValue) {
    final textStyle = Theme.of(context).textTheme.caption;
    return <Widget>[
      Text(
        (showWeekDay ? 'E HH:mm' : 'HH:mm').i18n.dateFormat(startValue),
        style: textStyle,
      ),
      OptionalBuilder(
        optional: end,
        builder: (_, endValue) => Text(
          ' - ${'HH:mm'.i18n.dateFormat(endValue)}',
          style: showWeekDay
              ? textStyle
              : textStyle.copyWith(color: textStyle.color.withOpacity(.33)),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => OptionalBuilder(
        optional: start,
        builder: (_, startValue) => Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildTimes(context, startValue),
        ),
      );
}
