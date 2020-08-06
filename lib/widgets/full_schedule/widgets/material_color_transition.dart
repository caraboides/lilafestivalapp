import 'package:flutter/material.dart';

class MaterialColorTransition extends ImplicitlyAnimatedWidget {
  MaterialColorTransition({
    Key key,
    @required this.color,
    @required this.child,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.linear,
  })  : assert(color != null),
        super(key: key, curve: curve, duration: duration);

  final Color color;
  final Widget child;

  @override
  _MaterialColorTransitionState createState() =>
      _MaterialColorTransitionState();
}

class _MaterialColorTransitionState
    extends AnimatedWidgetBaseState<MaterialColorTransition> {
  ColorTween _color;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _color = visitor(_color, widget.color, (value) => ColorTween(begin: value));
  }

  @override
  Widget build(BuildContext context) => Material(
        color: _color?.evaluate(animation),
        child: widget.child,
      );
}
