import 'package:dime/dime.dart';
import 'package:flutter/widgets.dart';

import '../models/global_config.dart';
import 'config.dart';

class GlobalModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<GlobalConfig>(config);
    addSingle<GlobalKey<NavigatorState>>(GlobalKey<NavigatorState>());
  }
}
