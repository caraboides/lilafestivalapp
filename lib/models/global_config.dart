import 'package:immortal/immortal.dart';

import 'reference.dart';

class GlobalConfig {
  const GlobalConfig({
    this.periodicRebuildDuration,
    this.privacyPolicyUrlDe,
    this.privacyPolicyUrlEn,
    this.festivalHubBaseUrl,
    this.repositoryUrl,
    this.creators,
    this.references,
    this.weatherBaseUrl,
    this.weatherApiKey,
  });

  final Duration periodicRebuildDuration;
  final String privacyPolicyUrlDe;
  final String privacyPolicyUrlEn;
  final String festivalHubBaseUrl;
  final String repositoryUrl;
  final ImmortalList<Reference> creators;
  final ImmortalList<Reference> references;
  final String weatherBaseUrl;
  final String weatherApiKey;
}
