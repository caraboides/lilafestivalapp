import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {'en_us': 'Loading bands.', 'de_de': 'Bands werden geladen.'} +
      {
        'en_us': 'There was an error retrieving the bands.',
        'de_de': 'Beim Laden der Bands ist ein Fehler aufgetreten.',
      };

  String get i18n => localize(this, _t);
}
