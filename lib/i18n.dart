import 'package:i18n_extension/i18n_extension.dart';

extension Localization on String {
  static final _t = Translations("en_us") +
      {
        "en_us": "Bands",
        "de_de": "Bands",
      } +
      {
        "en_us": "Day %d",
        "de_de": "Tag %d",
      };

  String get i18n => localize(this, _t);

  String fillList(List<Object> params) => localizeFill(this, params);

  String fill(Object param) => fillList([param]);
}
