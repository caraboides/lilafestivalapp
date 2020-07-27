import 'package:flutter/material.dart';

class VisibilityBuilder extends StatelessWidget {
  const VisibilityBuilder({this.builder, this.visible});

  final bool visible;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => Visibility(
        visible: visible,
        child: Builder(builder: builder),
      );
}
