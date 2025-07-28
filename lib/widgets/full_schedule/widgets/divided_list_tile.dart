import 'package:flutter/material.dart';

class DividedListTile extends StatelessWidget {
  const DividedListTile({required this.child, this.isLast = false, super.key});

  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) => isLast
      ? child
      : Container(
          decoration: BoxDecoration(
            border: Border(bottom: Divider.createBorderSide(context)),
          ),
          child: child,
        );
}
