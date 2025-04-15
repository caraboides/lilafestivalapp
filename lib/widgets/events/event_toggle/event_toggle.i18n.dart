import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {
        'en-US': 'Remove gig from schedule',
        'de-DE': 'Entferne Auftritt vom Plan',
      } +
      {'en-US': 'Add gig to schedule', 'de-DE': 'Füge Auftritt zum Plan hinzu'};

  String get i18n => localize(this, _t);
}
