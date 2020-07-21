import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:optional/optional.dart';

import '../models/band.dart';
import '../models/festival_config.dart';
import '../models/global_config.dart';
import '../utils/band_key.dart';
import '../utils/cache_stream.dart';
import '../utils/combined_storage_stream.dart';
import '../utils/constants.dart';

class BandsProvider
    extends StreamProviderFamily<ImmortalMap<String, Band>, String> {
  BandsProvider(BuildContext context)
      : super((ref, festivalId) => _createStream(
              ref: ref,
              festivalId: festivalId,
              context: context,
            ));

  static FestivalConfig get _config => dimeGet<FestivalConfig>();
  static GlobalConfig get _globalConfig => dimeGet<GlobalConfig>();

  static String _remoteUrl(String festivalId) => '/bands?festival=$festivalId';

  static ImmortalMap<String, Band> _fromJson(Map<String, dynamic> jsonMap) =>
      ImmortalMap<String, dynamic>(jsonMap)
          .mapValues((bandName, json) => Band.fromJson(bandName, json));

  static Stream<ImmortalMap<String, Band>> _createStream({
    @required ProviderReference ref,
    @required String festivalId,
    @required BuildContext context,
  }) =>
      festivalId == _config.festivalId
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
            );
}

class BandProvider extends ComputedFamily<AsyncValue<Optional<Band>>, BandKey> {
  BandProvider()
      : super((read, key) => read(dimeGet<BandsProvider>()(key.festivalId))
            .whenData((bands) => bands[key.bandName]));
}

class SortedBandsProvider
    extends ComputedFamily<AsyncValue<ImmortalList<Band>>, String> {
  SortedBandsProvider()
      : super((read, festivalId) =>
            read(dimeGet<BandsProvider>()(festivalId)).whenData(
              (bands) => bands.values.sort((a, b) => a.name.compareTo(b.name)),
            ));
}
