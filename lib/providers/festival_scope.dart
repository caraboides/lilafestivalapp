import 'package:dime/dime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FestivalScope {
  const FestivalScope({
    @required this.festivalId,
    this.isCurrentFestival = false,
    this.title,
  });

  final String festivalId;
  final String title;
  final bool isCurrentFestival;

  String get titleSuffix => title != null ? ' $title' : '';
}

class FestivalScopeModule extends BaseDimeModule {
  FestivalScopeModule(this.festivalScope);

  final FestivalScope festivalScope;

  @override
  void updateInjections() {
    addSingle<FestivalScope>(festivalScope);
  }
}
