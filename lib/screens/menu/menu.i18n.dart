import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Schedule',
        'de_de': 'Plan',
      } +
      {
        'en_us': 'My Schedule',
        'de_de': 'Mein Plan',
      } +
      // TODO(SF) these are flavor specific
      {
        'en_us': 'Location',
        'de_de': 'Anfahrt',
      } +
      {
        'en_us': 'FAQ',
        'de_de': 'FAQ',
      } +
      {
        'en_us': 'About',
        'de_de': 'Über diese App',
      } +
      {
        'en_us': 'Privacy Policy',
        'de_de': 'Datenschutzerklärung',
      };

  String get i18n => localize(this, _t);
}
