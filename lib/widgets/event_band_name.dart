import 'package:flutter/material.dart';

class EventBandName extends StatelessWidget {
  const EventBandName(this.bandName);

  final String bandName;

  @override
  Widget build(BuildContext context) => Text(
        bandName.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle2,
      );
}
