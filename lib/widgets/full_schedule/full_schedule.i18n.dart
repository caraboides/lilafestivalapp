import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en_us') +
      {'en_us': 'Bands', 'de_de': 'Bands'} +
      {'en_us': 'Day {number}', 'de_de': 'Tag {number}'} +
      {'en_us': 'Loading schedule.', 'de_de': 'Plan wird geladen.'} +
      {
        'en_us': 'There was an error retrieving the schedule.',
        'de_de': 'Beim Laden des Plans ist ein Fehler aufgetreten.',
      } +
      {'en_us': 'MMM dd', 'de_de': 'dd.MM.'} +
      {'en_us': 'Show full schedule', 'de_de': 'Vollständigen Plan anzeigen'} +
      {'en_us': 'Show my schedule only', 'de_de': 'Nur meinen Plan anzeigen'};

  String get i18n => localize(this, _t);
}
