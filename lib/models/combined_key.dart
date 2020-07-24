import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

@immutable
class CombinedKey<A, B> {
  const CombinedKey({
    @required this.key1,
    @required this.key2,
  });

  final A key1;
  final B key2;

  @override
  int get hashCode => hash2(key1.hashCode, key2.hashCode);

  @override
  bool operator ==(dynamic other) =>
      other is CombinedKey<A, B> && key1 == other.key1 && key2 == other.key2;
}
