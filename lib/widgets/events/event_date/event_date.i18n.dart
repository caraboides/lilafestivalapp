import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {'en_us': 'HH:mm', 'de_de': 'HH:mm'} +
      {'en_us': 'E HH:mm', 'de_de': 'E HH:mm'};

  String get i18n => localize(this, _t);
}
