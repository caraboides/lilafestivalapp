import 'package:flutter/material.dart';

class DividedListTile extends StatelessWidget {
  const DividedListTile({
    @required this.child,
    this.height,
    this.isLast = false,
  });

  final Widget child;
  final double height;
  final bool isLast;

  @override
  Widget build(BuildContext context) => isLast
      ? child
      : Container(
          foregroundDecoration: BoxDecoration(
            border: Border(
              bottom: Divider.createBorderSide(context),
            ),
          ),
          child: child,
        );
}