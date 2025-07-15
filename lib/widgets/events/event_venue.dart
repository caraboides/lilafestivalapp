import 'package:flutter/material.dart';

class EventVenue extends StatelessWidget {

  const EventVenue(this.venueName);

  final String venueName;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;
    return Text(
      venueName,
      style: textStyle?.copyWith(color: textStyle.color?.withAlpha(222)),
    );
  }
}
