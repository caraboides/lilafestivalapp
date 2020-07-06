import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': "Don't you like music?",
        'de_de': 'Magst du keine Musik?',
      } +
      {
        'en_us': 'You did not add any gigs to your schedule yet!',
        'de_de': 'Du hast noch keine Auftritte zu deinem Plan hinzugefügt!',
      };

  String get i18n => localize(this, _t);
}
