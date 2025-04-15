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
      };

  String get i18n => localize(this, _t);
}
