import 'package:i18n_extension/i18n_extension.dart';
import 'package:intl/intl.dart';

extension Interpolation on String {
  String fill(Map<String, Object> params) => params.entries.fold(
    this,
    (previousValue, entry) =>
        previousValue.replaceAll('{${entry.key}}', entry.value.toString()),
  );

  String dateFormat(DateTime date) =>
      DateFormat(this, I18n.locale.toString()).format(date.toLocal());
}
