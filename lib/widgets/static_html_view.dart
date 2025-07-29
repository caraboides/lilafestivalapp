import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/logging.dart';

class StaticHtmlView extends StatefulWidget {
  const StaticHtmlView({required this.buildHtml});

  final String Function(String fontUrl) buildHtml;

  @override
  State<StatefulWidget> createState() => StaticHtmlViewState();
}

class StaticHtmlViewState extends State<StaticHtmlView> {
  Logger get _log => const Logger(module: 'StaticHtmlView');
  late final WebViewController _controller;
  bool _loadingState = true;
  int _progress = 0;

  Future<String> _getFontUrl() async {
    final data = await rootBundle.load('assets/display_font.ttf');
    final buffer = data.buffer;
    return Uri.dataFromBytes(
      buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      mimeType: 'font/ttf',
    ).toString();
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _loadingState = false;
            });
          },
          onHttpError: (HttpResponseError error) {
            _log.error(
              'HTTP error: '
              '$error',
              error.toString(),
            );
          },
          onWebResourceError: (error) {
            _log.error(
              'Web resource failed to load: type ${error.errorType} code '
              '${error.errorCode} on url ${error.url}',
              error.description,
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('about:blank')) {
              return NavigationDecision.navigate;
            } else if (request.url.startsWith('http') ||
                request.url.startsWith('mailto')) {
              launchUrl(
                Uri.parse(request.url),
                mode: LaunchMode.externalApplication,
              );
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..enableZoom(false);
    _getFontUrl().then(
      (fontUrl) => _controller.loadHtmlString(widget.buildHtml(fontUrl)),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Visibility(
        visible: _loadingState,
        child: LinearProgressIndicator(value: _progress.toDouble()),
      ),
      Expanded(child: WebViewWidget(controller: _controller)),
    ],
  );
}
