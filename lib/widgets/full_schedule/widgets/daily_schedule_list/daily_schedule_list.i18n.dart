import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {
        'en-US': 'Loading running order.',
        'de-DE': 'Running Order wird geladen.',
      } +
      {
        'en-US': 'There was an error retrieving the running order.',
        'de-DE': 'Beim Laden der Running Order ist ein Fehler aufgetreten.',
      } +
      {
        'en-US': 'There is no schedule yet!',
        'de-DE': 'Es gibt noch keine Running Order!',
      } +
      {
        'en-US': 'Check again before the festival',
        'de-DE': 'Schau noch mal vor dem Festival nach',
      };

  String get i18n => localize(this, _t);
}
