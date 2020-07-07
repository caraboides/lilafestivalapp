import 'package:dime/dime.dart';

import '../models/global_config.dart';
import '../services/app_storage.dart';
import '../services/combined_storage.dart';
import '../services/festival_hub.dart';
import 'config.dart';

class GlobalModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<GlobalConfig>(config);
    addSingle<AppStorage>(AppStorage());
    addSingle<FestivalHub>(FestivalHub());
    addSingle<CombinedStorage>(CombinedStorage());
  }
}
