import 'package:flutter/material.dart';

import '../message_screen.dart';
import 'loading_screen.i18n.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen(this.description);

  final String description;

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        const LinearProgressIndicator(),
        MessageScreen(
          headline: 'Loading...'.i18n,
          description: description,
          icon: Icon(Icons.star_half),
        ),
      ]);
}
