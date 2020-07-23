import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';

import '../models/theme.dart';
import '../providers/festival_scope.dart';

class HistoryWrapper extends StatelessWidget {
  const HistoryWrapper({
    @required this.festivalScope,
    @required this.child,
  });

  final FestivalScope festivalScope;
  final Widget child;

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
        modules: <BaseDimeModule>[
          FestivalScopeModule(festivalScope),
        ],
        child: festivalScope.isCurrentFestival
            ? child
            : Theme(
                data: _theme.historyTheme,
                child: MaterialBannerTheme(
                  data: _theme.theme.bannerTheme,
                  child: Banner(
                    message: festivalScope.title,
                    location: BannerLocation.bottomEnd,
                    color: _theme.bannerBackgroundColor,
                    textStyle: _theme.bannerTextStyle,
                    child: child,
                  ),
                )),
      );
}
