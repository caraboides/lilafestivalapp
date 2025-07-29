import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'rules.i18n.dart';
import 'rules_en_html.dart';
import 'rules_html.dart';

String _shuttleHeader(String fontUrl) => '''
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <style>
    body {
      background-color: #1F211F;
      color: #FF9900;
      margin: 20px;
      font-family: sans-serif;
    }

    h1, h2, h3, h4, h5, h6 {
      color: #CCCCCC;
      font-family: 'DisplayFont';
      font-size: 27px;
      margin-top: 2em;
    }

    a {
      color: #FF9900;
      font-weight: bold;
      text-decoration: underline;
    }

    p {
      line-height: 1.5;
      margin-bottom: 1em;
    }

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
    }

    table td:last-child {
      border-right: none;
      background-color: #ffffff;
    }

    table tr:nth-of-type(even) {
      background-color: #eeeeee;
    }

    @font-face {
      font-family: 'DisplayFont';
      src: url($fontUrl);
    }
  </style>
</head>
''';

class Rules extends StatelessWidget {
  const Rules();

  static Widget builder(BuildContext context) => const Rules();

  static String path = '/rules';
  static String title() => 'Code of Conduct'.i18n;

  String _buildHtml(String fontUrl) =>
      _shuttleHeader(fontUrl) +
      (I18n.locale.languageCode == 'en-US' ? rulesEnHtml : rulesHtml);

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
    title: title(),
    body: StaticHtmlView(buildHtml: _buildHtml),
  );
}
