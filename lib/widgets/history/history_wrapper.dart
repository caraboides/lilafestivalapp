import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../../models/theme.dart';
import '../../providers/festival_scope.dart';

class HistoryWrapper extends StatelessWidget {
  const HistoryWrapper({required this.festivalScope, required this.child});

  final FestivalScope festivalScope;
  final Widget child;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
    scopeName: FestivalScope.scopeName,
    modules: <BaseDimeModule>[FestivalScopeModule(festivalScope)],
    child: festivalScope is HistoryFestivalScope
        ? Theme(
            data: _theme.historyTheme,
            child: Banner(
              message: (festivalScope as HistoryFestivalScope).title,
              location: BannerLocation.bottomEnd,
              color: _theme.bannerBackgroundColor,
              textStyle: _theme.bannerTextStyle,
              child: child,
            ),
          )
        : child,
  );
}
