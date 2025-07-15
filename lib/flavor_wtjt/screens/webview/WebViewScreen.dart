import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../model/history_item.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({required this.item, super.key});

  final HistoryItem item;

  @override
  Widget build(BuildContext context) {

    final controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            controller.runJavaScript('''
            const nav = document.querySelector('div[data-container="navigation"]');
            if (nav) nav.remove();

            const iconLabel = document.querySelector('label.jtpl-navigation__icon.jtpl-navigation__label');
            if (iconLabel) iconLabel.remove();

            const fallback = document.querySelector('div.jtpl-fallback');
            if (fallback) fallback.remove();
          ''');
          },
        ),
      )
      ..loadRequest(item.url);

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: WebViewWidget(controller: controller),
    );
  }

}