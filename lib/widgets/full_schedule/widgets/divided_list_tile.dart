import 'package:flutter/material.dart';

class DividedListTile extends StatelessWidget {
  const DividedListTile({
    required this.child,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  final Widget child;
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
