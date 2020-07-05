import 'package:immortal/immortal.dart';

import 'reference.dart';

class GlobalConfig {
  const GlobalConfig({
    this.periodicRebuildDuration,
    this.privacyPolicyUrl,
    this.festivalHubBaseUrl,
    this.repositoryUrl,
    this.creators,
    this.references,
  });

  final Duration periodicRebuildDuration;
  final String privacyPolicyUrl;
  final String festivalHubBaseUrl;
  final String repositoryUrl;
  final ImmortalList<Reference> creators;
  final ImmortalList<Reference> references;
}
