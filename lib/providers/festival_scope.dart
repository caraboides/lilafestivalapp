import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';

class FestivalScope {
  const FestivalScope({
    @required this.festivalId,
    String titleSuffix,
  }) : titleSuffix = titleSuffix != null ? ' $titleSuffix' : '';

  final String festivalId;
  final String titleSuffix;
}

class FestivalScopeModule extends BaseDimeModule {
  FestivalScopeModule(this.festivalScope);

  final FestivalScope festivalScope;

  @override
  void updateInjections() {
    addSingle<FestivalScope>(festivalScope);
  }
}
