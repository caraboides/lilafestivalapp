import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {
        'en_us': 'An error occurred!',
        'de_de': 'Es ist ein Fehler aufgetreten!',
      };

  String get i18n => localize(this, _t);
}
