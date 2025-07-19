import 'package:flutter_test/flutter_test.dart';
import 'package:immortal/immortal.dart';

import '../test_data.dart';

void main() {
  group('festival config', () {
    test('transforms date time to festival day', () {
      final testCases = [
        (DateTime(2025, 2, 23, 12, 0), DateTime(2025, 2, 23)),
        (DateTime(2025, 2, 23, 23, 59), DateTime(2025, 2, 23)),
        (DateTime(2025, 2, 24, 2, 59), DateTime(2025, 2, 23)),
        (DateTime(2025, 2, 24, 3, 0), DateTime(2025, 2, 24)),
      ];

      for (final (date, expected) in testCases) {
        expect(testFestivalConfig.toFestivalDay(date), expected);
      }
    });

    test('calculates correct festival days', () {
      final expected = ImmortalList.from([
        DateTime(2025, 2, 23),
        DateTime(2025, 2, 24),
        DateTime(2025, 2, 25),
      ]);
      expect(testFestivalConfig.festivalDays, expected);
    });
  });
}
