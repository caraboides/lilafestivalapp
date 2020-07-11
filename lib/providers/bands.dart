import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../utils/combined_storage_stream_provider.dart';

class BandsProvider
    extends CombinedStorageStreamProvider<ImmortalMap<String, Band>> {
  BandsProvider(BuildContext context, String festivalId)
      : super(
          context: context,
          remoteUrl: Optional.of('/bands?festival=$festivalId'),
          appStorageKey: Optional.of('bands.json'),
          assetPath: Optional.of('assets/bands.json'),
          fromJson: (jsonMap) => ImmortalMap<String, dynamic>(jsonMap)
              .mapValues((bandName, json) => Band.fromJson(bandName, json)),
        );
}
