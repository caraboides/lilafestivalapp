import 'package:dime/dime.dart';

import '../models/festival_config.dart';
import '../models/theme.dart';
import 'config.dart';
import 'theme.dart';

class FlavorModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<FestivalConfig>(config);
    addSingle<FestivalTheme>(festivalTheme);
  }
}
