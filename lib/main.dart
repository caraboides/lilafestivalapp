import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'models/festival_config.dart';
import 'models/theme.dart';
import 'providers/provider_module.dart';
import 'services/navigation.dart';
import 'services/notifications/notifications.dart';
import 'services/service_module.dart';
import 'utils/global_module.dart';
import 'widgets/initialization_widget.dart';

void runForFlavor(BaseDimeModule flavorModule) async {
  WidgetsFlutterBinding.ensureInitialized();

  dimeInstall(GlobalModule());
  dimeInstall(flavorModule);
  dimeInstall(ServiceModule());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    const ProviderScope(
      child: FestivalApp(),
    ),
  );
}

class FestivalApp extends StatelessWidget {
  const FestivalApp();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  void _precacheImages(BuildContext context) {
    if (_theme.logoMenu != null) {
      precacheImage(
        AssetImage(_theme.logoMenu.assetPath),
        context,
        size: Size(_theme.logoMenu.width, _theme.logoMenu.height),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _precacheImages(context);
    dimeGet<Notifications>().initializeNotificationPlugin();
    dimeInstall(ProviderModule(context), override: true);

    return InitializationWidget(
      MaterialApp(
        title: _config.festivalName,
        theme: _theme.theme,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('de', 'DE'),
        ],
        // TODO(SF) I18N necessary to wrap i18n per route? maybe root routes
        // only? or separate '/' route for init? > consider in 'isRoot' fn
        routes: dimeGet<Navigation>()
            .routesByPath
            .mapValues(
                (_, route) => (context) => I18n(child: route.builder(context)))
            .toMutableMap(),
      ),
    );
  }
}
