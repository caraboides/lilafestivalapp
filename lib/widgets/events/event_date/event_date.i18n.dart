import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'HH:mm', 'de-DE': 'HH:mm'} +
      {'en-US': 'E HH:mm', 'de-DE': 'E HH:mm'};

  String get i18n => localize(this, _t);
}
