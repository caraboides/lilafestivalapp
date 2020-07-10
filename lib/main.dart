import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

// TODO(SF) BUILD select correct flavor
import 'flavor_spirit/module.dart';
import 'models/festival_config.dart';
import 'models/theme.dart';
import 'providers/provider_module.dart';
import 'services/navigation.dart';
import 'services/service_module.dart';
import 'utils/global_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();
  dimeInstall(GlobalModule());
  dimeInstall(FlavorModule());
  dimeInstall(ServiceModule());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(
      const ProviderScope(
        child: FestivalApp(),
      ),
    );
  });
}

class FestivalApp extends StatelessWidget {
  const FestivalApp();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  void _precacheImages(BuildContext context) {
    // TODO(SF) BUILD perform flutter clean between flavor switches
    if (_theme.logoMenu != null) {
      precacheImage(
        AssetImage(_config.assetRootPath + _theme.logoMenu.assetPath),
        context,
        size: Size(_theme.logoMenu.width, _theme.logoMenu.height),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _precacheImages(context);
    // TODO(SF) NOTIFICATIONS
    // initializeNotifications();
    dimeInstall(ProviderModule(context), override: true);

    return MaterialApp(
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
      // TODO(SF) NOTIFICATIONS
      // home: InitializationWidget(
      //   child: ScheduleScreen(),
      // ),
      // TODO(SF) I18N necessary to wrap i18n per route? maybe root routes only?
      // or separate '/' route for init? > consider in 'isRoot' fn
      routes: dimeGet<Navigation>()
          .routesByPath
          .mapValues(
              (_, route) => (context) => I18n(child: route.builder(context)))
          .toMutableMap(),
    );
  }
}
