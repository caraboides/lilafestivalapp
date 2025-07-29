import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:i18n_extension/i18n_extension.dart';

import 'models/festival_config.dart';
import 'models/theme.dart';
import 'services/navigation.dart';
import 'services/service_module.dart';
import 'utils/global_module.dart';
import 'widgets/initialization_widget.dart';

Future<void> runForFlavor(BaseDimeModule flavorModule) async {
  WidgetsFlutterBinding.ensureInitialized();

  dimeInstall(GlobalModule());
  dimeInstall(flavorModule);
  dimeInstall(ServiceModule());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    ProviderScope(
      child: I18n(
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('de', 'DE')],
        child: const FestivalApp(),
      ),
    ),
  );
}

class FestivalApp extends StatelessWidget {
  const FestivalApp();

  FestivalTheme get _theme => dimeGet<FestivalTheme>();
  FestivalConfig get _config => dimeGet<FestivalConfig>();

  @override
  Widget build(BuildContext context) => InitializationWidget(
    child: MaterialApp(
      title: _config.festivalName,
      theme: _theme.theme,
      locale: I18n.locale,
      localizationsDelegates: I18n.localizationsDelegates,
      supportedLocales: I18n.supportedLocales,
      navigatorKey: dimeGet<GlobalKey<NavigatorState>>(),
      routes: dimeGet<Navigation>().namedRoutes.toMap(),
      navigatorObservers: [dimeGet<Navigation>().routeObserver],
    ),
  );
}
