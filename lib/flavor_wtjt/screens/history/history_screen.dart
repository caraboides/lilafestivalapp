import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/history_items.dart';
import '../webview/WebViewScreen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.separated(
        itemCount: historyItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final item = historyItems[i];
          return ListTile(
            title: Text(item.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WebViewScreen(item: item),
              ),
            ),
          );
        },
      ),
    );
}