import 'package:dime/dime.dart';

class FestivalScope {
  const FestivalScope._({
    required this.festivalId,
    this.isCurrentFestival = false,
    this.title,
  });

  factory FestivalScope.current(String festivalId) => FestivalScope._(
        festivalId: festivalId,
        isCurrentFestival: true,
      );

  factory FestivalScope.history({
    required String festivalId,
    required String title,
  }) =>
      FestivalScope._(
        festivalId: festivalId,
        title: title,
      );

  final String festivalId;
  final String? title;
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
