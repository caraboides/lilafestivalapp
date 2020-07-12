import 'package:flutter/material.dart';
import 'package:immortal/immortal.dart';

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
