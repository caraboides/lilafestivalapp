import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'Schedule', 'de-DE': 'Plan'} +
      {'en-US': 'My Schedule', 'de-DE': 'Mein Plan'};

  String get i18n => localize(this, _t);
}
