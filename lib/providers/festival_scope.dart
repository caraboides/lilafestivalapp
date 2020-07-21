import 'package:dime/dime.dart';

class FestivalIdProvider {
  const FestivalIdProvider(this.festivalId);

  final String festivalId;
}

class FestivalScopeModule extends BaseDimeModule {
  FestivalScopeModule(this.festivalId);

  final String festivalId;

  @override
  void updateInjections() {
    addSingle<FestivalIdProvider>(FestivalIdProvider(festivalId));
  }
}
