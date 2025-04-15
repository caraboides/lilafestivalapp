import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {
        // TODO(SF) I18n find better words
        'en-US': 'Gig is currently taking place',
        'de-DE': 'Auftritt findet gerade statt',
      };

  String get i18n => localize(this, _t);
}
