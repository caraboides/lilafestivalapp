import 'dart:async';

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
    addSingle<CombinedStorage>(const CombinedStorage());
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
        [int delayInMilliseconds = 0]) =>
    (_) =>
        Future.delayed(Duration(milliseconds: delayInMilliseconds), () => data);

Future<T> Function(Invocation) mockError<T>([int delayInMilliseconds = 0]) =>
    (_) => Future.delayed(Duration(milliseconds: delayInMilliseconds),
        () => throw Exception('Test'));

Future<Optional<dynamic>> Function(Invocation) mockOptionalResponse(
        TestData data,
        [int delayInMilliseconds = 0]) =>
    mockResponse(Optional.ofNullable(data?.toJson()), delayInMilliseconds);

Stream<TestData> createStream() => CombinedStorageStreamProvider.loadData(
      context: buildContextMock,
      remoteUrl: 'remoteUrl',
      appStorageKey: 'appStorageKey',
      assetPath: 'fallbackDataAssetPath',
      fromJson: (json) => TestData.fromJson(json),
      ref: MockProviderReference(),
    );

bool assertList(List<TestData> actual, List<String> expected) =>
    ImmortalList(actual)
        .map((data) => data.value)
        .equals(ImmortalList(expected));

const TestData remoteData = TestData('remoteData');
const TestData appStorageData = TestData('appStorageData');
const TestData assetData = TestData('assetData');
const String jsonAssetData = '{"value":"assetData"}';

void mockRemoteData([int delayInMilliseconds = 0, dynamic data = remoteData]) =>
    when(festivalHubMock.loadJsonData(any))
        .thenAnswer(mockOptionalResponse(data, delayInMilliseconds));

void mockAppStorageData(
        [int delayInMilliseconds = 0, dynamic data = appStorageData]) =>
    when(appStorageMock.loadJson(any))
        .thenAnswer(mockOptionalResponse(data, delayInMilliseconds));

void mockAssetData(
    [int delayInMilliseconds = 0, dynamic data = jsonAssetData]) {
  when(buildContextMock.dependOnInheritedWidgetOfExactType())
      .thenReturn(defaultAssetBundleMock);
  when(defaultAssetBundleMock.bundle).thenReturn(assetBundleMock);
  when(assetBundleMock.loadString(any))
      .thenAnswer(mockResponse(data, delayInMilliseconds));
}

Future<bool> assertStreamData(List<String> expectedData) async {
  final data = await createStream().toList();
  return assertList(data, expectedData);
}

void main() {
  group('StreamFallbackProvider', () {
    setUpAll(() {
      dimeInstall(TestModule());
      // Supress debug prints
      debugPrint = (message, {wrapWidth}) {};
    });

    test('resolves remote data only if returned first', () async {
      mockRemoteData();
      mockAppStorageData(10);
      expect(await assertStreamData(['remoteData']), true);
    });

    test('resolves app storage data before remote data', () async {
      mockRemoteData(10);
      mockAppStorageData(0);
      expect(await assertStreamData(['appStorageData', 'remoteData']), true);
    });

    test(
        'resolves asset data before remote data if app storage data is missing',
        () async {
      mockRemoteData(10);
      mockAppStorageData(0, null);
      mockAssetData();
      expect(await assertStreamData(['assetData', 'remoteData']), true);
    });

    test('resolves remote data only if no fallback was found', () async {
      mockRemoteData(10);
      mockAppStorageData(0, null);
      mockAssetData(0, null);
      expect(await assertStreamData(['remoteData']), true);
    });

    test('resolves app data only if loading remote data failed first',
        () async {
      mockRemoteData(0, null);
      mockAppStorageData(10);
      expect(await assertStreamData(['appStorageData']), true);
    });

    test('resolves app data only if loading remote data failed afterwards',
        () async {
      mockRemoteData(10, null);
      mockAppStorageData(0);
      expect(await assertStreamData(['appStorageData']), true);
    });

    test(
        'resolves asset data only if loading remote and app storage data '
        'failed first', () async {
      mockRemoteData(0, null);
      mockAppStorageData(10, null);
      mockAssetData();
      expect(await assertStreamData(['assetData']), true);
    });

    test(
        'resolves asset data only if loading remote and app storage data '
        'failed afterwards', () async {
      mockRemoteData(15, null);
      mockAppStorageData(10, null);
      mockAssetData();
      expect(await assertStreamData(['assetData']), true);
    });

    test('throws error if loading all data failed, offline returned first',
        () async {
      mockRemoteData(15, null);
      mockAppStorageData(10, null);
      mockAssetData(0, null);
      expect(createStream().toList(), throwsException);
    });

    test('throws error if loading all data failed, remote returned first',
        () async {
      mockRemoteData(0, null);
      mockAppStorageData(10, null);
      mockAssetData(0, null);
      expect(createStream().toList(), throwsException);
    });
  });
}
