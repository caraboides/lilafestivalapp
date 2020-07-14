import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../utils/combined_storage_stream_provider.dart';

class BandsProvider
    extends CombinedStorageStreamProvider<ImmortalMap<String, Band>> {
  BandsProvider(BuildContext context, String festivalId)
      : super(
          context: context,
          remoteUrl: '/bands?festival=$festivalId',
          appStorageKey: 'bands.json',
          assetPath: 'assets/bands.json',
          fromJson: (jsonMap) => ImmortalMap<String, dynamic>(jsonMap)
              .mapValues((bandName, json) => Band.fromJson(bandName, json)),
        );
}

class BandProvider extends ComputedFamily<AsyncValue<Optional<Band>>, String> {
  BandProvider()
      : super((read, bandName) => read(dimeGet<BandsProvider>())
            .whenData((bands) => bands[bandName]));
}

class SortedBandsProvider extends Computed<AsyncValue<ImmortalList<Band>>> {
  SortedBandsProvider()
      : super((read) => read(dimeGet<BandsProvider>()).whenData(
            (bands) => bands.values.sort((a, b) => a.name.compareTo(b.name))));
}
