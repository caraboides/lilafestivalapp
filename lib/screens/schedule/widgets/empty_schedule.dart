import 'package:flutter/material.dart';

import 'empty_schedule.i18n.dart';

class EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: <Widget>[
              Text("Don't you like music?".i18n),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Icon(Icons.star_border),
              ),
              Text('You did not add any gigs to your schedule yet!'.i18n),
            ],
          ),
        ),
      );
}