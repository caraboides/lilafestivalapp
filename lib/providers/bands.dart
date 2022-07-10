import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/band_key.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';

typedef BandsProvider = StreamProviderFamily<ImmortalMap<String, Band>, String>;

typedef BandProvider = ProviderFamily<AsyncValue<Optional<Band>>, BandKey>;

// ignore: avoid_classes_with_only_static_members
class BandsProviderCreator {
  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  static GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  static String _remoteUrl(String festivalId) => '/bands?festival=$festivalId';

  static ImmortalMap<String, Band> _fromJson(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(jsonMap)
          .mapValues((bandName, json) => Band.fromJson(bandName, json));

  // TODO(SF) autodispose for history festivals..
  static BandsProvider create(BuildContext context) =>
      StreamProvider.family<ImmortalMap<String, Band>, String>(
          (ref, festivalId) => festivalId == _config.festivalId
              ? createCombinedStorageStream(
                  context: context,
                  ref: ref,
                  remoteUrl: _remoteUrl(festivalId),
                  appStorageKey: Constants.bandsAppStorageFileName,
                  assetPath: Constants.bandsAssetFileName,
                  fromJson: _fromJson,
                )
              : createCacheStream(
                  remoteUrl:
                      _globalConfig.festivalHubBaseUrl + _remoteUrl(festivalId),
                  fromJson: _fromJson,
                ));

  static BandProvider createBandProvider() =>
      Provider.family<AsyncValue<Optional<Band>>, BandKey>((ref, key) => ref
          .read(dimeGet<BandsProvider>()(key.festivalId))
          .whenData((bands) => bands[key.bandName]));
}
