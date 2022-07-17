import 'package:flutter_test/flutter_test.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/models/event.dart';
import 'package:optional/optional.dart';

final startDate = DateTime(2022, 8, 1, 18, 0);

final events = ImmortalList([
  Event(
      bandName: 'band',
      id: 'id1',
      stage: 'stage',
      start: Optional.of(startDate.add(const Duration(hours: 1))),
      end: const Optional.empty()),
  Event(
      bandName: 'band',
      id: 'id2',
      stage: 'stage',
      start: const Optional.empty(),
      end: const Optional.empty()),
  Event(
      bandName: 'band',
      id: 'id3',
      stage: 'stage',
      start: Optional.of(startDate),
      end: const Optional.empty()),
  Event(
      bandName: 'band',
      id: 'id4',
      stage: 'stage',
      start: Optional.of(startDate.add(const Duration(hours: 1))),
      end: const Optional.empty())
]);

void main() {
  group('events', () {
    test('sorts events by start date', () {
      expect(
        ['id3', 'id1', 'id4', 'id2'],
        events.sort().map((event) => event.id),
      );
    });
  });
}
