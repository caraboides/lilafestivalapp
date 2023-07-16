import 'package:flutter/material.dart';

import '../../../widgets/scaffold.dart';
import '../../../widgets/static_html_view.dart';
import 'faq.i18n.dart';
import 'faq_en_html.dart';
import 'faq_html.dart';

const String _faqHeader = '''
    <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
    @font-face {
      font-family: 'Impacted2';
      src: url('https://www.party-san.de/typo3conf/ext/theme_psoa/Resources/Public/Fonts/Impacted2/Impacted20-Regular.woff2?v=4.6.3') format('woff');
    }
    h3 {
      font-family: 'Impacted2';
      font-size: 27px;
    }
    body {
      margin: 20px;
    }
    a:link, a:visited {
      color: #9da400;
    }
    </style>
    </head>
    ''';

class FAQ extends StatelessWidget {
  const FAQ();

  static Widget builder(BuildContext context) => const FAQ();

  static String title() => 'FAQ'.i18n;

  String _buildHtml(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return _faqHeader + (locale.languageCode == 'en' ? faqEnHtml : faqHtml);
  }

  @override
  Widget build(BuildContext context) => AppScaffold.withTitle(
        title: title(),
        body: StaticHtmlView(_buildHtml(context)),
      );
}
