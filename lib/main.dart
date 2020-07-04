import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n_extension/i18n_widget.dart';

import 'flavor/module.dart';
import 'models/config.dart';
import 'models/theme.dart';
import 'providers/module.dart';
import 'screens/home.dart';

void main() {
  dimeInstall(FlavorModule());
  dimeInstall(ProviderModule());
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
      //   child: HomeScreen(),
      // ),
      // TODO(SF) does i18n work with routes?
      home: I18n(
        child: HomeScreen(),
      ),
      // routes: {
      //   'home': (context) => HomeScreen(),
      //   'mySchedule': (context) => HomeScreen(favoritesOnly: true),
      //   'drive': (context) => Drive(),
      //   'faq': (context) => FAQ(),
      //   'about': (context) => About(),
      // },
    );
  }
}
