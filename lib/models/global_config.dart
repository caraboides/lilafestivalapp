import 'package:immortal/immortal.dart';

import 'reference.dart';

class GlobalConfig {
  const GlobalConfig({
    required this.periodicRebuildDuration,
    required this.privacyPolicyUrlDe,
    required this.privacyPolicyUrlEn,
    required this.festivalHubBaseUrl,
    required this.repositoryUrl,
    required this.creators,
    required this.references,
    required this.weatherBaseUrl,
    required this.weatherApiKey,
    required this.weatherMinHour,
    required this.scheduleReloadDuration,
  });

  final Duration periodicRebuildDuration;
  final Uri privacyPolicyUrlDe;
  final Uri privacyPolicyUrlEn;
  final String festivalHubBaseUrl;
  final Uri repositoryUrl;
  final ImmortalList<Reference> creators;
  final ImmortalList<Reference> references;
  final String weatherBaseUrl;
  final String weatherApiKey;
  final int weatherMinHour;
  final Duration scheduleReloadDuration;
}
