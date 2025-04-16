import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/band_key.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../models/ids.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';

typedef BandsProvider =
    StreamProviderFamily<ImmortalMap<BandName, Band>, FestivalId>;

typedef BandProvider = ProviderFamily<AsyncValue<Optional<Band>>, BandKey>;

class BandsProviderCreator {
  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  static GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  static String _remoteUrl(FestivalId festivalId) =>
      '/bands?festival=$festivalId';

  static ImmortalMap<BandName, Band> _fromJson(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(
        jsonMap,
      ).mapValues((bandName, json) => Band.fromJson(bandName, json));

  static BandsProvider create(BuildContext context) =>
      StreamProvider.family<ImmortalMap<BandName, Band>, FestivalId>((
        ref,
        festivalId,
      ) {
        if (festivalId == _config.festivalId) {
          return createCombinedStorageStream(
            context: context,
            ref: ref,
            remoteUrl: _remoteUrl(festivalId),
            appStorageKey: Constants.bandsAppStorageFileName,
            assetPath: Constants.bandsAssetFileName,
            fromJson: _fromJson,
          );
        }
        // TODO(SF): autodispose?
        return createCacheStream(
          remoteUrl: _globalConfig.festivalHubBaseUrl + _remoteUrl(festivalId),
          fromJson: _fromJson,
        );
      });

  static BandProvider createBandProvider() =>
      Provider.family<AsyncValue<Optional<Band>>, BandKey>(
        (ref, bandKey) => ref
            .watch(dimeGet<BandsProvider>()(bandKey.festivalId))
            .whenData((bands) => bands[bandKey.bandName]),
      );
}
