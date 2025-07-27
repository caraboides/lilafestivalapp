import 'package:flutter_test/flutter_test.dart';
import 'package:lilafestivalapp/models/band_with_events.dart';
import 'package:optional/optional.dart';

import '../test_data.dart';

void main() {
  group('band with events', () {
    test('should correctly determine if playing', () {
      final bandWithEvents = BandWithEvents(
        band: const Optional.empty(),
        events: createBandEvents(),
        bandName: '',
      );
      final testCases = [
        (testFestivalConfig.startDate.add(const Duration(hours: 1)), false),
        (testFestivalConfig.startDate.add(const Duration(hours: 2)), true),
        (testFestivalConfig.startDate.add(const Duration(hours: 3)), false),
        (
          testFestivalConfig.startDate.add(
            const Duration(hours: 4, minutes: 30),
          ),
          true,
        ),
        (testFestivalConfig.startDate.add(const Duration(days: 2)), false),
      ];

      for (final testCase in testCases) {
        expect(bandWithEvents.isPlaying(testCase.$0), testCase.$1);
      }
    });
  });
}
