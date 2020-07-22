import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';

class FestivalScope {
  const FestivalScope({
    @required this.festivalId,
    this.isCurrentFestival = false,
    this.titleSuffix,
  });

  final String festivalId;
  final String titleSuffix;
  final bool isCurrentFestival;

  String get titleSuffixString => titleSuffix != null ? ' $titleSuffix' : '';
}

class FestivalScopeModule extends BaseDimeModule {
  FestivalScopeModule(this.festivalScope);

  final FestivalScope festivalScope;

  @override
  void updateInjections() {
    addSingle<FestivalScope>(festivalScope);
  }
}
