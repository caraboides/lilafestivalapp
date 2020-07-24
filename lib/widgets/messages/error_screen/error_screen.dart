import 'package:flutter/material.dart';

import '../message_screen.dart';
import 'error_screen.i18n.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.description);

  final String description;

  @override
  Widget build(BuildContext context) => MessageScreen(
        headline: 'An error occurred!'.i18n,
        description: description,
        // TODO(SF) FEATURE retry
        icon: const Text('💀', style: TextStyle(fontSize: 24)),
      );
}
