import 'package:flutter/material.dart';

class EventStage extends StatelessWidget {
  const EventStage(this.stage);

  final String stage;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.caption;
    return Text(
      stage,
      style: textStyle?.copyWith(color: textStyle.color?.withOpacity(.87)),
    );
  }
}
