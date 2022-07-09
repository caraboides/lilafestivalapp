import 'combined_key.dart';

class BandKey extends CombinedKey<String, String> {
  const BandKey({
    required String festivalId,
    required String bandName,
  }) : super(key1: festivalId, key2: bandName);

  String get festivalId => key1;
  String get bandName => key2;
}
