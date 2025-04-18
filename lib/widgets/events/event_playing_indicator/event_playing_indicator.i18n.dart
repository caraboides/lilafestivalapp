import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {
        // TODO(SF): I18n find better words
        'en_us': 'Gig is currently taking place',
        'de_de': 'Auftritt findet gerade statt',
      };

  String get i18n => localize(this, _t);
}
