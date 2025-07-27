import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'Bands', 'de-DE': 'Bands'} +
      {'en-US': 'Day {number}', 'de-DE': 'Tag {number}'} +
      {'en-US': 'Loading schedule.', 'de-DE': 'Plan wird geladen.'} +
      {
        'en-US': 'There was an error retrieving the schedule.',
        'de-DE': 'Beim Laden des Plans ist ein Fehler aufgetreten.',
      } +
      {'en-US': 'MMM dd', 'de-DE': 'dd.MM.'} +
      {'en-US': 'Show full schedule', 'de-DE': 'Vollständigen Plan anzeigen'} +
      {'en-US': 'Show my schedule only', 'de-DE': 'Nur meinen Plan anzeigen'};

  String get i18n => localize(this, _t);
}
