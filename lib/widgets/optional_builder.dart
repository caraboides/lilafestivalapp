import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

typedef OptionalWidgetBuilder<T> =
    Widget Function(BuildContext context, T value);

class OptionalBuilder<T> extends StatelessWidget {
  const OptionalBuilder({required this.builder, required this.optional});

  final Optional<T> optional;
  final OptionalWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) => Visibility(
    visible: optional.isPresent,
    child: Builder(builder: (context) => builder(context, optional.value)),
  );
}
