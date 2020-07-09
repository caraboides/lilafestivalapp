import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'flavor/module.dart';
import 'models/festival_config.dart';
import 'models/theme.dart';
import 'providers/provider_module.dart';
import 'services/navigation.dart';
import 'services/service_module.dart';
import 'utils/global_module.dart';

void main() {
  dimeInstall(GlobalModule());
  dimeInstall(FlavorModule());
  dimeInstall(ServiceModule());

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) async {
    runApp(
      ProviderScope(
        child: FestivalApp(),
      ),
    );
  });
}

class FestivalApp extends StatelessWidget {
  const FestivalApp();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();

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
    // initializeNotifications();
    // TODO(SF) still problem on app restart? other solution?
    dimeInstall(ProviderModule(context), override: true);

    return MaterialApp(
      title: dimeGet<FestivalConfig>().festivalName,
      theme: _theme.theme,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('de', 'DE'),
      ],
      // home: InitializationWidget(
      //   child: ScheduleScreen(),
      // ),
      // TODO(SF) necessary to wrap i18n per route? maybe root routes only?
      // or separate '/' route for init? > consider in 'isRoot' fn
      routes: dimeGet<Navigation>()
          .routesByPath
          .mapValues(
              (_, route) => (context) => I18n(child: route.builder(context)))
          .toMutableMap(),
    );
  }
}
