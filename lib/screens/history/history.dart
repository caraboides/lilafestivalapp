import 'package:dime/dime.dart';
import 'package:flutter/material.dart';

import '../../models/app_route.dart';
import '../../models/festival_config.dart';
import '../../widgets/scaffold.dart';
import 'history.i18n.dart';

class History extends StatelessWidget {
  const History({
    this.festivalId,
    this.festivalTitle,
  });

  final String festivalId;
  final String festivalTitle;

  static Widget builder(BuildContext context, NestedRoute nestedRoute) =>
      History(
        festivalId: nestedRoute.key,
        festivalTitle: nestedRoute.title,
      );

  static String title() => 'History'.i18n;

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  @override
  Widget build(BuildContext context) => AppScaffold(
        title: '${_config.festivalName} $festivalTitle',
        body: Center(child: Text('History of $festivalId')),
      );
}
