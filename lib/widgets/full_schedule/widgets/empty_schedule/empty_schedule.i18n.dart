import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': "Don't you like music?", 'de-DE': 'Magst du keine Musik?'} +
      {
        'en-US': 'You did not add any gigs to your schedule yet!',
        'de-DE': 'Du hast noch keine Auftritte zu deinem Plan hinzugefügt!',
      };

  String get i18n => localize(this, _t);
}
