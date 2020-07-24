import 'package:flutter/material.dart';

import '../../../messages/message_screen.dart';
import 'empty_schedule.i18n.dart';

class EmptySchedule extends StatelessWidget {
  const EmptySchedule();

  // TODO(SF) THEME use different text for history?
  @override
  Widget build(BuildContext context) => MessageScreen(
        headline: "Don't you like music?".i18n,
        description: 'You did not add any gigs to your schedule yet!'.i18n,
        icon: Icon(Icons.star_border),
      );
}
