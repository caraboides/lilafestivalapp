import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';

class Drive extends StatelessWidget {
  const Drive();

  static Widget builder(BuildContext context) => Drive();

  List<Widget> _buildList(List<String> content) => content
      .expand((item) => [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(width: 10),
                Text('●', style: TextStyle(fontSize: 11)),
                SizedBox(width: 10),
                Expanded(child: Text(item)),
              ],
            ),
            SizedBox(height: 10),
          ])
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      title: 'Anfahrt',
      body: ListView(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          children: <Widget>[
            Text(
              'Adresse: Flugplatz / Altes Lager, 14913 Niedergörsdorf',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Anreise mit Zug:',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Ganz einfach: Bis Berlin, dann mit der Regionalbahn nach '
              'Jüterbog.',
            ),
            SizedBox(height: 10),
            Text(
              'Unseren Shuttleservice können wir in diesem Jahr, aus '
              'verschiedenen Gründen, nicht anbieten. Das finden wir selbst '
              'sehr bedauerlich.',
            ),
            SizedBox(height: 10),
            Text(
              'Die Taxiunternehmen am Bahnhof wissen allerdings Bescheid. Wenn '
              'ihr einzeln anreist, bildet Gruppen und nehmt euch ein '
              'Großraumtaxi. Die Fahrt zum Gelände kostest euch dann auch '
              'nicht mehr als unser sonstiger Shuttle. Wir hätten es gerne '
              'anders gelöst, aber manchmal sind selbst uns die Hände '
              'gebunden.',
            ),
            SizedBox(height: 30),
            Text(
              'Anreise mit dem Auto:',
              style: theme.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ..._buildList([
              'über die A9, Abfahrt Niemegk, dann die B 102 Richtung Jüterbog',
              'über die A 13, Abfahrt Duben oder Freiwalde',
              'über die A 10, Abfahrt Ludwigsfelde Ost',
            ]),
            Text(
              'ab Altes Lager einfach der Ausschilderung folgen!!! (Und bitte '
              'lasst die Beschilderung stehen. Festivalposter gibt es, sofern '
              'noch vorhanden, am Infostand!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ]),
    );
  }
}
