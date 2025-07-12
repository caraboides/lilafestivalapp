import 'package:flutter/material.dart';
import 'package:i18n_extension/i18n_extension.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'faq.i18n.dart';
import 'faq_en_html.dart';
import 'faq_html.dart';

String _faqHeader(String fontUrl) => '''
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
    @font-face {
      font-family: 'DisplayFont';
      src: url($fontUrl);
    }
    h3 {
      font-family: 'DisplayFont';
      font-size: 27px;
    }
    body {
      margin: 20px;
    }
    a:link, a:visited {
      color: #E4BB8A;
    }
    </style>
    </head>
    ''';

class FAQ extends StatelessWidget {
  const FAQ();

  static Widget builder(BuildContext context) => const FAQ();

  static String path = '/faq';
  static String title() => 'FAQ'.i18n;

  String _buildHtml(String fontUrl) =>
      _faqHeader(fontUrl) + (I18n.locale.languageCode == 'en' ? faqEnHtml : faqHtml);

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
    title: title(),
    body: StaticHtmlView(buildHtml: _buildHtml),
  );
}
