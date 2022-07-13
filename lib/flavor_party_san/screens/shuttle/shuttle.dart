import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'shuttle.i18n.dart';
import 'shuttle_en_html.dart';
import 'shuttle_html.dart';

const String _shuttleHeader = '''
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link href="https://fonts.googleapis.com/css?family=Pirata+One&display=swap" rel="stylesheet">

  <style>
    td,
    th {
      text-align: center;
    }

    table {
      border: none;
      border-collapse: collapse;
      width: 100%;
    }

    table td {
      border-left: 1px solid #000;
      border-right: 1px solid #000;
    }

    table td:first-child {
      border-left: none;
      // background-color: #ffffff;
    }

    table td:last-child {
      border-right: none;
      background-color: #ffffff;
    }

    table tr:nth-of-type(even) {
      background-color: #eeeeee;
    }

    h2 {
      font-family: 'Pirata One';
      font-size: 27px;
    }

    body {
      margin: 20px;
    }
  </style>
</head>
''';

class Shuttle extends StatelessWidget {
  const Shuttle();

  static Widget builder(BuildContext context) => const Shuttle();

  static String title() => 'Bus Shuttle'.i18n;

  String _buildHtml(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return _shuttleHeader +
        (locale.languageCode == 'en' ? shuttleEnHtml : shuttleHtml);
  }

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
        title: title(),
        body: StaticHtmlView(_buildHtml(context)),
      );
}
