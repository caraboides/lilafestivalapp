import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'FAQ',
        'de_de': 'FAQ',
      };

  String get i18n => localize(this, _t);
}
