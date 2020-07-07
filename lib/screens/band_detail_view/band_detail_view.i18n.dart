import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations('en_us') +
      {
        'en_us': 'Band Details',
        'de_de': 'Band Details',
      } +
      {
        'en_us': 'Sorry, no info',
        'de_de': 'Sorry, keine Infos',
      } +
      {
        'en_us': 'Origin',
        'de_de': 'Herkunft',
      } +
      {
        'en_us': 'Roots',
        'de_de': 'Wurzeln',
      } +
      {
        'en_us': 'Style',
        'de_de': 'Stil',
      } +
      {
        'en_us': 'Play on Spotify',
        'de_de': 'Reinhören bei Spotify',
      } +
      // TODO(SF) duplicates from event list item! > create separate widget
      {
        'en_us': 'Remove gig from schedule',
        'de_de': 'Entferne Auftritt vom Plan',
      } +
      {
        'en_us': 'Add gig to schedule',
        'de_de': 'Füge Auftritt zum Plan hinzu',
      } +
      {
        'en_us': 'HH:mm',
        'de_de': 'HH:mm',
      } +
      {
        'en_us': 'E HH:mm',
        'de_de': 'E HH:mm',
      };

  String get i18n => localize(this, _t);
}
