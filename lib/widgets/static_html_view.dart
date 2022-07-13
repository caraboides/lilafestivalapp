import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/logging.dart';

class StaticHtmlView extends HookWidget {
  const StaticHtmlView(this.html);

  final String html;

  Logger get _log => const Logger(module: 'StaticHtmlView');

  String _buildUrl(BuildContext context) {
    final contentBase64 = base64Encode(const Utf8Encoder().convert(html));
    return 'data:text/html;base64,$contentBase64';
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = useState(true);
    return Column(
      children: <Widget>[
        Visibility(
          visible: loadingState.value,
          child: const LinearProgressIndicator(),
        ),
        Expanded(
          child: WebView(
            zoomEnabled: false,
            initialUrl: _buildUrl(context),
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) {
              launchUrl(Uri.parse(request.url));
              return NavigationDecision.prevent;
            },
            onPageFinished: (_) {
              loadingState.value = false;
            },
            onWebResourceError: (error) {
              _log.error(
                'Web resource failed to load: type ${error.errorType} code '
                '${error.errorCode} on url ${error.failingUrl}',
                error.description,
              );
            },
          ),
        ),
      ],
    );
  }
}
