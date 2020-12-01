import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';
import 'faq.i18n.dart';

class FAQ extends StatelessWidget {
  const FAQ();

  static Widget builder(BuildContext context) => const FAQ();

  static String title() => 'FAQ'.i18n;

  List<Widget> _buildSection(
          ThemeData theme, String title, List<Widget> content) =>
      <Widget>[
        Text(
          title,
          style: theme.textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ...content.expand((widget) => <Widget>[
              widget,
              const SizedBox(height: 10),
            ]),
        const SizedBox(height: 20),
      ];

  List<Widget> _buildTextList(List<String> content) =>
      content.map((text) => Text(text)).toList();

  List<Widget> _buildList(List<String> content) => _buildTextList(content)
      .map((item) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('●', style: TextStyle(fontSize: 11)),
              ),
              Expanded(child: item),
            ],
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      title: 'Fragen & Antworten',
      body: ListView(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        children: <Widget>[
          ..._buildSection(theme, 'Vorweg:', <Widget>[
            const Text(
              'Was wir nicht wollen:',
            ),
            ..._buildList([
              'Nazis, Faschos, Rassisten, AFD-Spinner, Reichsbürger, '
                  'Aluhutträger oder sonstiges, ideologisch rechtes Pack, '
                  'homophobe und sexistische Arschlöcher, Macker o.ä. Ihr habt '
                  'bei uns rein Garnichts verloren und seid schon gar nicht '
                  'willkommen. Wir sind ein buntes, offenes und friedliches '
                  'Festivalvolk!',
              'Hunde oder andere Haustiere!',
              'Kein Glas auf dem gesamten Gelände!',
              'Keine Gewalt, Aggressives Verhalten o.ä. Seid nett und '
                  'freundlich zueinander, habt einfach Spaß!',
            ]),
            ..._buildTextList([
              'Bitte nehmt diese Punkte ernst, denn wir tun es auf jeden Fall '
                  'und greifen im Notfall durch. Wir wollen schließlich alle '
                  'ein tolles Festival!',
              'Wem irgendetwas von den obigen Punkten auffällt, kann sich '
                  'jederzeit vertrauensvoll an unsere Security wenden. Auch '
                  'bei allen anderen Sorgen und Nöten stehen euch der '
                  'Infostand und die Security zur Verfügung. Macht davon '
                  'Gebrauch!',
            ]),
          ]),
          ..._buildSection(theme, 'Geländeöffnungszeiten', <Widget>[
            ..._buildTextList([
              'Ihr könnt ab Mittwoch, den 28.08.2019 anreisen. Park- und '
                  'Zeltplatz sind ab dann dauerhaft geöffnet.',
              'Das Festivalgelände mit den Bühnen, Essens-, Getränke- und '
                  'Merchandise-Ständen ist ab folgenden Zeiten geöffnet:',
            ]),
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Donnerstag:'),
                    const Text('Freitag:'),
                    const Text('Samstag:'),
                  ],
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('16 Uhr'),
                    const Text('13 Uhr'),
                    const Text('11 Uhr'),
                  ],
                ),
              ],
            ),
          ]),
          ..._buildSection(
            theme,
            'Tickets',
            <Widget>[
              ..._buildTextList([
                'Tickets, die bis Freitag, den 23.8.2019 bezahlt wurden, '
                    'werden noch verschickt. Ihr könnt bis einschließlich '
                    'Montag, den 26.08.2019 Tickets über die Homepage '
                    'bestellen. Diese werden an der Kasse vor Ort auf euren '
                    'Namen hinterlegt. Klamotten, die nicht mehr rechtzeitig '
                    'versendet werden können, werden am Infostand hinterlegt.',
                'Ansonsten bekommt Ihr weiterhin Karten an allen bekannten '
                    'Vorverkaufsstellen. Für die Faulen, die '
                    'Kurzentschlossenen oder für diejenigen, die einfach zu '
                    'viel Geld haben, gibt es noch ausreichend Tickets an der '
                    'Abendkasse für alle Tage:',
              ]),
              const Text(
                'Vorverkauf: 62.- Eur (für das gesamte Festival)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                'Abendkasse: 72.- Eur (für das gesamte Festival)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                'Freitag (inkl. Do.): 48.- Eur (VVK, Abendkasse etwas teurer)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                'Samstag: 45.- Eur (VVK, Abendkasse etwas teurer)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          ..._buildSection(theme, 'Zelten & Parken', <Widget>[
            const Text(
              'Wie in den letzten Jahren auch, ist das Zelten und Parken nicht '
              'getrennt. Ihr dürft also neben eurem Auto campieren. Dabei gilt '
              'natürlich weiterhin: Achtet auf eure Nachbarn, parkt niemanden '
              'zu und beschädigt keine Fahrzeuge. Es wird diesbezüglich auch '
              'hinreichend patrouilliert. Sollte es doch derartige '
              'Vorkommnisse geben, wendet euch bitte an die Security!',
            ),
            const Text(
              'Keine Hämmer oder große Messer!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            const Text(
              'Erlaubt sind normale '
              'GUMMIHAMMER in handelsüblicher Größe. Bitte lasst sonstiges '
              'Werkzeug zu Hause. In der Vergangenheit haben wir zu oft '
              'erlebt, dass Vorschlaghämmer, Äxte o.ä. aussortiert werden '
              'mussten. Sowas hat auf einem Festival nichts verloren. Der '
              'Boden ist kein Beton und Zeltheringe bekommt ihr damit '
              'problemlos rein. MESSER bitte in handelsüblicher Größe. '
              'Normales Besteck geht klar, aber keine Macheten, '
              'Fleischermesser oder sonstige Gerätschaften, welche niemand auf '
              'einem Festival benötigt.',
            ),
          ]),
          ..._buildSection(theme, 'Essen & Trinken', <Widget>[
            const Text(
              'Auf den Zeltplatz dürft ihr wie immer alles mitnehmen, was das '
              'kulinarische Herz begehrt, jedoch mit 2 Einschränkungen:',
            ),
            const Text(
              'Kein Glas',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            const Text(
              'Füllt bitte ALLES in Plastikbehälter um! Auch Gurken, '
              'Ketchup, Nutella oder dergleichen. Keine Teelichtgläser, '
              'Laternen oder sonstiger Klimbim in und aus Glas. Es wird '
              'rigoros aussortiert und es wäre schade um eure Schätze!',
            ),
            const Text(
              'Kein offenes Feuer',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            const Text(
              'Aufgrund der prekären Wetterlage und '
              'anhaltender Dürre ist auch unser Gelände hochentzündlich. Daher '
              'sind EINWEGGRILLS, die quasi direkt auf dem Boden stehen, '
              'verboten! Erlaubt sind hingegen 3-Bein-Grills ab einer Höhe von '
              '30cm. Im besten Fall habt bitte einen Feuerlöscher, Wasser- '
              'oder Sandeimer zum Löschen parat. Gleiches gilt für Gaskocher. '
              'Betrieb nur auf festen und geraden Unterlagen. Offenes Feuer '
              'ist ebenso strengstens verboten! Beachtet diese Hinweise '
              'dringend. Die Sicherheitslage bezüglich Feuer ist auch in '
              'diesem Sommer besonders hoch.',
            ),
            const Text(
              'Wem das alles zu anstrengend ist, der bekommt auf dem '
              'Festivalgelände ausreichend und abwechslungsreiche Kost geboten '
              '(natürlich auch vegetarisch UND vegan).',
            ),
          ]),
          ..._buildSection(
            theme,
            'Tiere',
            _buildTextList([
              'Tiere haben auf Festivals grundsätzlich absolut NICHTS '
                  'verloren. Wir lieben Tiere und aus genau diesem Grund sind '
                  'wir der Meinung, dass das ganz klar der falsche Ort für die '
                  'lieben Vier-, Sechs-, Achtbeiner etc. ist.',
              'Es ist einfach zu laut, zu stressig und viel zu anstrengend für '
                  'die Liebsten, also gebt sie bitte für die Tage eures '
                  'Besuches in vertrauensvolle Obhut. Danke!',
            ]),
          ),
          ..._buildSection(
            theme,
            'Toiletten & Duschen',
            _buildTextList([
              'Mittlerweile Kult und auch 2019 wieder dabei: Die Dusch- und '
                  'Kackmaut!',
              'Für 8.-€ erhaltet ihr am Infostand (neben dem Eingang zum '
                  'Festivalgelände) das beliebte Bändchen, mit welchem ihr das '
                  'gesamte Wochenende unbegrenzt die Duschen und Spültoiletten '
                  'benutzen könnt. Wer nur einmal den Luxus genießen möchte, '
                  'zahlt bitte direkt bei unserem charmanten Toilettenteam.',
              'Für diejenigen, die auf Luxus verzichten können gibt es '
                  'natürlich auf dem gesamten Gelände jede Menge '
                  'Dixi-Toiletten, die regelmäßig gereinigt werden.',
              'Bitte habt im Hinterkopf, dass die Wasserversorgung auf unserem '
                  'Gelände äußerst schwierig ist und wir mit riesigen '
                  'Wassersäcken arbeiten, die nur sehr langsam befüllt werden '
                  'können. Auch wenn es in diesem Jahr sehr heiß ist, geht '
                  'bitte vernünftig mit den Wasservorräten und der Anlage um. '
                  'Mutwillig herbeigeführte Verstopfungen oder offene Hähne '
                  'schaden euch und uns. Danke!',
            ]),
          ),
          ..._buildSection(
            theme,
            'Notstromaggregate',
            _buildTextList([
              'Wie unter dem Punkt FEUER bereits erwähnt, ist die diesjährige '
                  'Trockenheit besonders gefährlich für Material und Mensch. '
                  'Nach sorgfältiger Abwägung erlauben wir Notstromer NUR '
                  'unter der Bedingung, dass ein handelsüblicher Feuerlöscher '
                  'mitgeführt wird.',
              'Sollte dieser nicht vorhanden sind, darf das Aggregat nicht mit '
                  'aufs Gelände. Bitte achtet unbedingt darauf und sagt es '
                  'weiter. Wenn das Gerät nicht betrieben werden muss, schont '
                  'bitte, vor allem nachts, eure Mitcamper und stellt die '
                  'Geräte ab, Danke!',
            ]),
          ),
        ],
      ),
    );
  }
}
