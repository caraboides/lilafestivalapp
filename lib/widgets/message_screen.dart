import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({
    this.headline,
    this.description,
    this.icon,
  });

  final String headline;
  final String description;
  final Widget icon;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          children: <Widget>[
            Text(headline, style: Theme.of(context).textTheme.headline4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: icon,
            ),
            Text(description),
          ],
        ),
      );
}
