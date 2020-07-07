import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Band Details',
        'de_de': 'Band Details',
      } +
      {
        'en_us': 'Sorry, no info',
        'de_de': 'Sorry, keine Infos',
      } +
      {
        'en_us': 'Origin',
        'de_de': 'Herkunft',
      } +
      {
        'en_us': 'Roots',
        'de_de': 'Wurzeln',
      } +
      {
        'en_us': 'Style',
        'de_de': 'Stil',
      } +
      {
        'en_us': 'Play on Spotify',
        'de_de': 'Reinhören bei Spotify',
      };

  String get i18n => localize(this, _t);
}
