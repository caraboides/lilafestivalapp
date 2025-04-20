import 'package:dime_flutter/dime_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/theme.dart';
import '../../../../providers/festival_scope.dart';
import '../../../../providers/schedule.dart';
import 'missing_schedule_banner.i18n.dart';

class MissingScheduleBanner extends HookConsumerWidget {
  FestivalTheme get _theme => dimeGet<FestivalTheme>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalScope = DimeFlutter.get<FestivalScope>(context);
    final provider = ref.watch(
      dimeGet<FestivalDaysProvider>()(festivalScope.festivalId),
    );

    return provider.maybeMap(
      data:
          (days) => Visibility(
            visible:
                !(festivalScope is HistoryFestivalScope) && days.value.isEmpty,
            child: Card(
              child: Container(
                alignment: Alignment.center,
                height: _theme.cardBannerHeight,
                child: Text('There is no schedule yet!'.i18n),
              ),
            ),
          ),
      orElse: () => Container(),
    );
  }
}
