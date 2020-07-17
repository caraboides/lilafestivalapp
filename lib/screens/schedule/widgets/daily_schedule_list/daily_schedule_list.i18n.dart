import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Loading running order.',
        'de_de': 'Running Order wird geladen.',
      } +
      {
        'en_us': 'There was an error retrieving the running order.',
        'de_de': 'Beim Laden der Running Order ist ein Fehler aufgetreten.'
      };

  String get i18n => localize(this, _t);
}
