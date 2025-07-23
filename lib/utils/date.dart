import 'package:dime/dime.dart';

import '../models/festival_config.dart';

bool isSameFestivalDay(DateTime date1, DateTime date2) {
  final date = date1.subtract(dimeGet<FestivalConfig>().daySwitchOffset);
  return date.year == date2.year &&
      date.month == date2.month &&
      date.day == date2.day;
}

DateTime toFestivalDay(DateTime date) =>
    dimeGet<FestivalConfig>().toFestivalDay(date);

DateTime currentDate() => DateTime.now();
