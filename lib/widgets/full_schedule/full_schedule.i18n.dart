import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Bands',
        'de_de': 'Bands',
      } +
      {
        'en_us': 'Day {number}',
        'de_de': 'Tag {number}',
      } +
      {
        'en_us': 'Show full schedule',
        'de_de': 'Vollständigen Plan anzeigen',
      } +
      {
        'en_us': 'Show my schedule only',
        'de_de': 'Nur meinen Plan anzeigen',
      };

  String get i18n => localize(this, _t);
}
