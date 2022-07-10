import 'package:dime/dime.dart';

class FestivalScope {
  const FestivalScope(this.festivalId);

  final String festivalId;

  static const scopeName = 'festival';

  String get titleSuffix => '';
}

class HistoryFestivalScope extends FestivalScope {
  const HistoryFestivalScope({
    required String festivalId,
    required this.title,
  }) : super(festivalId);

  final String title;

  @override
  String get titleSuffix => ' $title';
}

class FestivalScopeModule extends BaseDimeModule {
  FestivalScopeModule(this.festivalScope);

  final FestivalScope festivalScope;

  @override
  void updateInjections() {
    addSingle<FestivalScope>(festivalScope);
  }
}
