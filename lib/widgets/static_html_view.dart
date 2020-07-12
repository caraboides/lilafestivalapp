import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StaticHtmlView extends StatelessWidget {
  const StaticHtmlView(this.html);

  final String html;

  String _buildUrl(BuildContext context) {
    final contentBase64 = base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }

  @override
  Widget build(BuildContext context) => WebView(
        initialUrl: _buildUrl(context),
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (request) {
          launch(request.url);
          return NavigationDecision.prevent;
        },
        onWebResourceError: (error) {
          print('Web resource failed to load: type ${error.errorType} code '
              '${error.errorCode} on url ${error.failingUrl}: '
              '${error.description}');
        },
      );
}
