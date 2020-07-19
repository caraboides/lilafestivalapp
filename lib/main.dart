import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'models/festival_config.dart';
import 'models/theme.dart';
import 'services/navigation.dart';
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

  @override
  Widget build(BuildContext context) => InitializationWidget(
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
          routes: dimeGet<Navigation>().namedRoutes.toMutableMap(),
        ),
      );
}
