import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {
        'en_us': 'Remove gig from schedule',
        'de_de': 'Entferne Auftritt vom Plan',
      } +
      {'en_us': 'Add gig to schedule', 'de_de': 'Füge Auftritt zum Plan hinzu'};

  String get i18n => localize(this, _t);
}
