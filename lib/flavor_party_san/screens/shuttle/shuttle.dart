import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'shuttle.i18n.dart';
import 'shuttle_en_html.dart';
import 'shuttle_html.dart';

String _shuttleHeader(String fontUrl) => '''
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

    @font-face {
      font-family: 'DisplayFont';
      src: url($fontUrl);
    }

    h2 {
      font-family: 'DisplayFont';
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

  static String path = '/shuttle';
  static String title() => 'Bus Shuttle'.i18n;

  String _buildHtml(String fontUrl) =>
      _shuttleHeader(fontUrl) +
      (I18n.language == 'en' ? shuttleEnHtml : shuttleHtml);

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
    title: title(),
    body: StaticHtmlView(buildHtml: _buildHtml),
  );
}
