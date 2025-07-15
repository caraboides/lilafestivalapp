import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t =
      Translations.byText('en-US') +
      {'en-US': 'Gig Reminder', 'de-DE': 'Auftrittsbenachrichtigungen'} +
      {
        'en-US': 'Notifications to remind of liked gigs',
        // TODO(SF): I18n find better words
        'de-DE': 'Benachrichtigungen für favorisierte Auftritte',
      } +
      {'en-US': 'HH:mm', 'de-DE': 'HH:mm'} +
      {
        'en-US': '{band} plays at {time} on the {stage}!',
        'de-DE': '{band} spielen um {time} auf der {stage}!',
      };

  String get i18n => localize(this, _t);
}
