import 'combined_key.dart';
import 'ids.dart';

class BandKey extends CombinedKey<FestivalId, String> {
  const BandKey({required FestivalId festivalId, required String bandName})
    : super(key1: festivalId, key2: bandName);

  FestivalId get festivalId => key1;
  String get bandName => key2;
}
