import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';

class ToggleLikeButton extends StatelessWidget {
  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  static const _iconSize = 24.0;

  final VoidCallback onPressed;
  final Color? iconColor;
  final bool toggleState;
  final String tooltip;
  final bool dense;

  const ToggleLikeButton({
    required this.toggleState,
    required this.onPressed,
    required this.tooltip,
    this.iconColor,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = dense ? _theme.toggleDenseIconSize : _theme.toggleIconSize;
    return Semantics(
      button: true,
      enabled: true,
      child: InkResponse(
        onTap: onPressed,
        splashColor: _theme.toggleSplashColor,
        radius:
            dense
                ? _theme.toggleDenseSplashRadius
                : Material.defaultSplashRadius,
        child: Tooltip(
          message: tooltip,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: size, minHeight: size),
            child: Container(
              height: _iconSize,
              width: _iconSize,
              alignment: Alignment.center,
              child: AnimatedCrossFade(
                firstChild: Icon(Icons.star, color: iconColor),
                secondChild: Icon(Icons.star_border, color: iconColor),
                crossFadeState:
                    toggleState
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 150),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
