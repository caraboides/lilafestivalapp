import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'Band Details', 'de-DE': 'Band Details'} +
      {'en-US': 'Sorry, no info', 'de-DE': 'Sorry, keine Infos'} +
      {'en-US': 'Origin', 'de-DE': 'Herkunft'} +
      {'en-US': 'Roots', 'de-DE': 'Wurzeln'} +
      {'en-US': 'Style', 'de-DE': 'Stil'} +
      {'en-US': 'Homepage', 'de-DE': 'Homepage'} +
      {'en-US': 'Social', 'de-DE': 'Social'} +
      {'en-US': 'added on', 'de-DE': 'hinzugefügt'} +
      {'en-US': 'MMM dd yyyy', 'de-DE': 'dd.MM.yyyy'} +
      {'en-US': 'Play on Spotify', 'de-DE': 'Reinhören bei Spotify'} +
      {
        'en-US': 'There was an error retrieving band data.',
        'de-DE': 'Beim Laden der Band-Daten ist ein Fehler aufgetreten.',
      } +
      {'en-US': 'Loading band data.', 'de-DE': 'Band-Daten werden geladen.'};

  String get i18n => localize(this, _t);
}
