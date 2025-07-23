import 'package:flutter_test/flutter_test.dart';
import 'package:lilafestivalapp/models/combined_key.dart';

void main() {
  group('combined key', () {
    test('it should calculate correct hash', () {
      const key1 = CombinedKey(key1: '1', key2: '2');
      const key2 = CombinedKey(key1: '2', key2: '1');
      const key3 = CombinedKey(key1: '1', key2: '2');

      expect(key1.hashCode, 526957398);
      expect(key2.hashCode, 254666465);
      expect(key1.hashCode, key3.hashCode);
    });

    test('it should correctly compare keys', () {
      const key1 = CombinedKey(key1: '1', key2: '2');
      const key2 = CombinedKey(key1: '1', key2: '2');
      const key3 = CombinedKey(key1: '1', key2: '3');

      expect(key1 == key1, true);
      expect(key1 == key2, true);
      expect(key1 == key3, false);
    });
  });
}
