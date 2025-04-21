import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {
        'en_us': 'Loading running order.',
        'de_de': 'Running Order wird geladen.',
      } +
      {
        'en_us': 'There was an error retrieving the running order.',
        'de_de': 'Beim Laden der Running Order ist ein Fehler aufgetreten.',
      } +
      {
        'en_us': 'There is no schedule yet!',
        'de_de': 'Es gibt noch keine Running Order!',
      } +
      {
        'en_us': 'Check again before the festival',
        'de_de': 'Schau noch mal vor dem Festival nach',
      };

  String get i18n => localize(this, _t);
}
