import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';
import 'drive.i18n.dart';

class Drive extends StatelessWidget {
  const Drive();

  static Widget builder(BuildContext context) => const Drive();

  static String path = '/drive';
  static String title() => 'Location'.i18n;

  List<Widget> _buildList(List<String> content) => content
      .expand(
        (item) => [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('●', style: TextStyle(fontSize: 11)),
              ),
              Expanded(child: Text(item)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold.withTitle(
      title: 'Anfahrt',
      body: ListView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        children: <Widget>[
          const Text(
            'Adresse: Flugplatz / Altes Lager, 14913 Niedergörsdorf',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          const SizedBox(height: 30),
          Text(
            'Anreise mit Zug:',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            'Ganz einfach: Bis Berlin, dann mit der Regionalbahn nach '
            'Jüterbog.',
          ),
          const SizedBox(height: 10),
          const Text(
            'Unseren Shuttleservice können wir in diesem Jahr, aus '
            'verschiedenen Gründen, nicht anbieten. Das finden wir selbst '
            'sehr bedauerlich.',
          ),
          const SizedBox(height: 10),
          const Text(
            'Die Taxiunternehmen am Bahnhof wissen allerdings Bescheid. Wenn '
            'ihr einzeln anreist, bildet Gruppen und nehmt euch ein '
            'Großraumtaxi. Die Fahrt zum Gelände kostest euch dann auch '
            'nicht mehr als unser sonstiger Shuttle. Wir hätten es gerne '
            'anders gelöst, aber manchmal sind selbst uns die Hände '
            'gebunden.',
          ),
          const SizedBox(height: 30),
          Text(
            'Anreise mit dem Auto:',
            style: theme.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ..._buildList([
            'über die A9, Abfahrt Niemegk, dann die B 102 Richtung Jüterbog',
            'über die A 13, Abfahrt Duben oder Freiwalde',
            'über die A 10, Abfahrt Ludwigsfelde Ost',
          ]),
          const Text(
            'ab Altes Lager einfach der Ausschilderung folgen!!! (Und bitte '
            'lasst die Beschilderung stehen. Festivalposter gibt es, sofern '
            'noch vorhanden, am Infostand!',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
