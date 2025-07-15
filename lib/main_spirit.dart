import 'flavor_spirit/module.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // falls nötig
import 'package:intl/intl.dart'; // nur falls du intl nutzt
import 'package:i18n_extension/i18n_extension.dart';  // für I18n.locale
import 'main.dart';
import 'main.dart';

void main() {

  Intl.defaultLocale = 'en-US'; //
  // Jetzt App starten
  runForFlavor(FlavorModule());
}
