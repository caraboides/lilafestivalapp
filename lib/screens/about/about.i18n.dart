import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'About', 'de-DE': 'Über diese App'} +
      {
        'en-US': 'This is an unofficial app for the {festival}:',
        'de-DE': 'Dies ist eine inoffizielle App für das {festival}:',
      } +
      {
        'en-US': 'Source code can be found under',
        'de-DE': 'Der Quellcode ist hier zu finden:',
      } +
      {
        'en-US': 'Created by Projekt LilaHerz',
        'de-DE': 'Entwickelt von Projekt LilaHerz',
      } +
      {'en-US': 'Weather data provided by:', 'de-DE': 'Wetterdaten von:'} +
      {'en-US': 'Font "{font}" by:', 'de-DE': 'Schriftart "{font}" von:'} +
      {'en-US': '{festivalName} App', 'de-DE': '{festivalName} App'} +
      {
        'en-US': 'Copyright 2019 - 2020 Projekt LilaHerz 💜',
        'de-DE': 'Copyright 2019 - 2020 Projekt LilaHerz 💜',
      };

  String get i18n => localize(this, _t);
}
