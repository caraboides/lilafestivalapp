import 'package:dime_flutter/dime_flutter.dart';
import 'package:dime_flutter/flutter_scope.dart';
import 'package:flutter/material.dart';

import '../../models/festival_config.dart';
import '../../providers/festival_scope.dart';
import '../../widgets/full_schedule/widgets/band_schedule_list/band_schedule_list.dart';
import '../../widgets/scaffold.dart';
import 'bands.i18n.dart';

class BandsScreen extends StatelessWidget {
  const BandsScreen();

  static Widget builder(BuildContext context) => const BandsScreen();

  static String path = '/bands';
  static String title() => 'Bands'.i18n;

  FestivalConfig get _config => dimeGet<FestivalConfig>();

  @override
  Widget build(BuildContext context) => DimeScopeFlutter(
    scopeName: FestivalScope.scopeName,
    modules: <BaseDimeModule>[
      FestivalScopeModule(_config.currentFestivalScope),
    ],
    child: AppScaffold.withTitle(
      title: title(),
      body: const BandScheduleList(),
    ),
  );
}
