import 'package:dime/dime.dart';

import 'app_storage.dart';
import 'combined_storage.dart';
import 'festival_hub.dart';
import 'navigation.dart';
import 'open_weather.dart';

class ServiceModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<Navigation>(Navigation());
    addSingle<AppStorage>(AppStorage());
    addSingle<FestivalHub>(FestivalHub());
    addSingle<CombinedStorage>(CombinedStorage());
    addSingle<OpenWeather>(OpenWeather());
  }
}
