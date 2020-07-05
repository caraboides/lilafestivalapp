import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'About',
        'de_de': 'Über diese App',
      } +
      {
        'en_us': 'This is an unofficial app for the {festival}:',
        'de_de': 'Dies ist eine inoffizielle App für das {festival}:',
      } +
      {
        'en_us': 'Source code can be found under',
        'de_de': 'Der Quellcode ist hier zu finden:',
      } +
      {
        'en_us': 'Created by Projekt LilaHerz',
        'de_de': 'Entwickelt von Projekt LilaHerz',
      } +
      {
        'en_us': 'Weather data provided by:',
        'de_de': 'Wetterdaten von:',
      } +
      {
        'en_us': 'Font "{font}" by:',
        'de_de': 'Schriftart "{font}" von:',
      } +
      {
        'en_us': '{festivalName} App',
        'de_de': '{festivalName} App',
      } +
      {
        'en_us': 'Copyright 2019 - 2020 Projekt LilaHerz 💜',
        'de_de': 'Copyright 2019 - 2020 Projekt LilaHerz 💜'
      };

  String get i18n => localize(this, _t);
}
