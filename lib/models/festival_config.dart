import 'package:immortal/immortal.dart';

import 'reference.dart';

// TODO(SF) add required annotations or similiar
class FestivalConfig {
  const FestivalConfig({
    this.festivalName,
    this.festivalFullName,
    this.festivalUrl,
    this.startDate,
    this.endDate,
    this.daySwitchOffset,
    this.fontReferences,
    this.aboutMessages,
  });

  final String festivalName;
  final String festivalFullName;
  final String festivalUrl;
  final DateTime startDate;
  final DateTime endDate;
  final Duration daySwitchOffset;
  final ImmortalList<Reference> fontReferences;
  final ImmortalList<Reference> aboutMessages;

  ImmortalList<DateTime> get days => ImmortalList.generate(
      endDate.difference(startDate).inDays + 1,
      (index) => DateTime(
            startDate.year,
            startDate.month,
            startDate.day + index,
          ));
}
