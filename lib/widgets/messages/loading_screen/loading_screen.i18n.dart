import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Loading...',
        'de_de': 'Lädt...',
      };

  String get i18n => localize(this, _t);
}
