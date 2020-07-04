import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {
        "en_us": "Bands",
        "de_de": "Bands",
      } +
      {
        "en_us": "Day {number}",
        "de_de": "Tag {number}",
      };

  String get i18n => localize(this, _t);

  String fill(Map<String, Object> params) => params.entries.fold(
      this,
      (previousValue, entry) =>
          previousValue.replaceAll('{${entry.key}}', entry.value.toString()));
}
