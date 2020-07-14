import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Gig Reminder',
        'de_de': 'Auftrittsbenachrichtigungen',
      } +
      {
        'en_us': 'Notifications to remind of liked gigs',
        // TODO(SF) I18n find better words
        'de_de': 'Benachrichtigungen für favorisierte Auftritte',
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
