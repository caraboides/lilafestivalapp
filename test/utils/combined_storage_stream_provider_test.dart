import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/services/combined_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:optional/optional.dart';

import 'package:lilafestivalapp/utils/combined_storage_stream_provider.dart';
import 'package:lilafestivalapp/services/app_storage.dart';
import 'package:lilafestivalapp/services/festival_hub.dart';

class MockAppStorage extends Mock implements AppStorage {}

class MockFestivalHub extends Mock implements FestivalHub {}

class MockBuildContext extends Mock implements BuildContext {}

// ignore: must_be_immutable
class MockDefaultAssetBundle extends Mock implements DefaultAssetBundle {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockAssetBundle extends Mock implements AssetBundle {}

class MockProviderReference extends Mock implements ProviderReference {}

final MockAppStorage appStorageMock = MockAppStorage();
final MockFestivalHub festivalHubMock = MockFestivalHub();
final MockBuildContext buildContextMock = MockBuildContext();
final MockDefaultAssetBundle defaultAssetBundleMock = MockDefaultAssetBundle();
final MockAssetBundle assetBundleMock = MockAssetBundle();

class TestModule extends BaseDimeModule {
  @override
  void updateInjections() {
    addSingle<AppStorage>(appStorageMock);
    addSingle<FestivalHub>(festivalHubMock);
    addSingle<CombinedStorage>(CombinedStorage());
  }
}

class TestData {
  const TestData(this.value);

  factory TestData.fromJson(json) => TestData(json['value']);

  final String value;

  @override
  String toString() => value;

  dynamic toJson() => {'value': value};
}

Future<T> Function(Invocation) mockResponse<T>(T data,
        [int milliseconds = 0]) =>
    (_) => Future.delayed(Duration(milliseconds: milliseconds), () => data);

Future<Optional<dynamic>> Function(Invocation) mockOptionalResponse(
        TestData data,
        [int milliseconds = 0]) =>
    mockResponse(Optional.ofNullable(data?.toJson()), milliseconds);

Stream<TestData> createStream() => CombinedStorageStreamProvider.loadData(
      context: buildContextMock,
      remoteUrl: Optional.of('remoteUrl'),
      appStorageKey: Optional.of('appStorageKey'),
      assetKey: Optional.of('fallbackDataAssetKey'),
      fromJson: (json) => TestData.fromJson(json),
      ref: MockProviderReference(),
    );

bool assertList(List<TestData> actual, List<String> expected) =>
    ImmortalList(actual)
        .map((data) => data.value)
        .equals(ImmortalList(expected));

final TestData remoteData = TestData('remoteData');
final TestData appStorageData = TestData('appStorageData');
final TestData assetData = TestData('assetData');

void main() {
  group('StreamFallbackProvider', () {
    setUpAll(() {
      dimeInstall(TestModule());
    });

    test('resolves remote data only if returned first', () async {
      when(festivalHubMock.loadJsonData(any))
          .thenAnswer(mockOptionalResponse(remoteData));
      when(appStorageMock.loadJson(any))
          .thenAnswer(mockOptionalResponse(appStorageData, 10));
      final data = await createStream().toList();
      expect(assertList(data, ['remoteData']), true);
    });

    test('resolves app storage data before remote data', () async {
      when(festivalHubMock.loadJsonData(any))
          .thenAnswer(mockOptionalResponse(remoteData, 10));
      when(appStorageMock.loadJson(any))
          .thenAnswer(mockOptionalResponse(appStorageData, 0));
      final data = await createStream().toList();
      expect(assertList(data, ['appStorageData', 'remoteData']), true);
    });

    test(
        'resolves asset data before remote data if app storage data is missing',
        () async {
      when(festivalHubMock.loadJsonData(any))
          .thenAnswer(mockOptionalResponse(remoteData, 10));
      when(appStorageMock.loadJson(any))
          .thenAnswer(mockOptionalResponse(null, 0));
      when(buildContextMock.dependOnInheritedWidgetOfExactType())
          .thenReturn(defaultAssetBundleMock);
      when(defaultAssetBundleMock.bundle).thenReturn(assetBundleMock);
      when(assetBundleMock.loadString(any))
          .thenAnswer(mockResponse('{"value":"assetData"}', 0));
      final data = await createStream().toList();
      expect(assertList(data, ['assetData', 'remoteData']), true);
    });

    test('resolves remote data only if no fallback was found', () async {
      when(festivalHubMock.loadJsonData(any))
          .thenAnswer(mockOptionalResponse(remoteData));
      when(appStorageMock.loadJson(any))
          .thenAnswer(mockOptionalResponse(null, 0));
      when(buildContextMock.dependOnInheritedWidgetOfExactType())
          .thenReturn(defaultAssetBundleMock);
      when(defaultAssetBundleMock.bundle).thenReturn(assetBundleMock);
      when(assetBundleMock.loadString(any)).thenAnswer(mockResponse(null, 0));
      final data = await createStream().toList();
      expect(assertList(data, ['remoteData']), true);
    });
  });
}
