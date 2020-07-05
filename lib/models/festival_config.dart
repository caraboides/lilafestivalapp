import 'package:immortal/immortal.dart';

// TODO(SF) add required annotations or similiar
class FestivalConfig {
  const FestivalConfig({
    this.festivalName,
    this.startDate,
    this.endDate,
    this.daySwitchOffset,
  });

  final String festivalName;
  final DateTime startDate;
  final DateTime endDate;
  final Duration daySwitchOffset;

  ImmortalList<DateTime> get days => ImmortalList.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => DateTime(
            startDate.year,
            startDate.month,
            startDate.day + index,
          ));
}
