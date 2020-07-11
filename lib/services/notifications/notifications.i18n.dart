import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Gig Reminder',
        'de_de': 'Auftrittsbenachrichtigungen',
      } +
      {
        'en_us': 'Notifications to remind of scheduled gigs',
        'de_de': 'Benachrichtigungen für eingeplante Auftritte',
      } +
      {
        'en_us': 'HH:mm',
        'de_de': 'HH:mm',
      } +
      {
        'en_us': '{band} plays at {time} on the {stage}!',
        'de_de': '{band} spielen um {time} auf der {stage}!',
      };

  String get i18n => localize(this, _t);
}
