import 'package:flutter/material.dart';

class MaterialColorTransition extends ImplicitlyAnimatedWidget {
  const MaterialColorTransition({
    required this.color,
    required this.child,
    super.key,
    super.duration = const Duration(milliseconds: 350),
    super.curve,
  });

  final Color color;
  final Widget child;

  @override
  _MaterialColorTransitionState createState() =>
      _MaterialColorTransitionState();
}

class _MaterialColorTransitionState
    extends AnimatedWidgetBaseState<MaterialColorTransition> {
  ColorTween? _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color =
        visitor(
              _color,
              widget.color,
              (value) => ColorTween(begin: value as Color?),
            )
            as ColorTween?;
  }

  @override
  Widget build(BuildContext context) =>
      Material(color: _color?.evaluate(animation), child: widget.child);
}
