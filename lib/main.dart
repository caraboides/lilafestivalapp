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

  // void _precacheImages(BuildContext context) {
  //   precacheImage(
  //     AssetImage('assets/icon_menu.png'),
  //     context,
  //     size: Size(304, 152),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // _precacheImages(context);
    // initializeNotifications();
    // TODO(SF) this may only be executed once! (problem on app restart)
    // TODO(SF) override flag?
    dimeInstall(ProviderModule(context), override: true);

    return MaterialApp(
      title: dimeGet<FestivalConfig>().festivalName,
      theme: dimeGet<FestivalTheme>().theme,
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
