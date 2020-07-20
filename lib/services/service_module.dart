import 'package:dime/dime.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app_storage.dart';
import 'combined_storage.dart';
import 'festival_hub.dart';
import 'navigation.dart';
import 'notifications/notifications.dart';
import 'open_weather.dart';

class ServiceModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<Navigation>(const Navigation());
    addSingle<AppStorage>(AppStorage());
    addSingle<FestivalHub>(const FestivalHub());
    addSingle<CombinedStorage>(const CombinedStorage());
    addSingle<OpenWeather>(OpenWeather());
    addSingle<FlutterLocalNotificationsPlugin>(
        FlutterLocalNotificationsPlugin());
    addSingle<Notifications>(const Notifications());
    addSingle<BaseCacheManager>(DefaultCacheManager());
  }
}
