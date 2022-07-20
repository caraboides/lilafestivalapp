import 'dart:async';

import 'package:dime/dime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/services/app_storage.dart';
import 'package:lilafestivalapp/services/combined_storage.dart';
import 'package:lilafestivalapp/services/festival_hub.dart';
import 'package:lilafestivalapp/utils/combined_storage_stream.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:optional/optional.dart';

import '../test_utils.dart';
import 'combined_storage_stream_test.mocks.dart';

@GenerateMocks([
  AppStorage,
  FestivalHub,
  BuildContext,
  AssetBundle,
  DefaultAssetBundle,
])
class MockProviderReference extends Mock implements Ref {}

final MockAppStorage appStorageMock = MockAppStorage();
final MockFestivalHub festivalHubMock = MockFestivalHub();
final MockBuildContext buildContextMock = MockBuildContext();
final MockDefaultAssetBundle defaultAssetBundleMock = MockDefaultAssetBundle();
final MockAssetBundle assetBundleMock = MockAssetBundle();

const periodicDuration = Duration(milliseconds: 100);

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

Future<Optional<dynamic>> Function(Invocation) mockOptionalResponse(
        TestData? data,
        [int delayInMilliseconds = 0]) =>
    mockResponse(Optional.ofNullable(data?.toJson()), delayInMilliseconds);

Stream<TestData> createStream([Duration? periodicDuration]) =>
    createCombinedStorageStream(
      context: buildContextMock,
      remoteUrl: 'remoteUrl',
      appStorageKey: 'appStorageKey',
      assetPath: 'fallbackDataAssetPath',
      fromJson: (json) => TestData.fromJson(json),
      ref: MockProviderReference(),
      periodicDuration: periodicDuration,
    );

bool assertList(List<TestData> actual, List<String> expected) =>
    ImmortalList(actual)
        .map((data) => data.value)
        .equals(ImmortalList(expected));

const TestData remoteData = TestData('remoteData');
const TestData remoteUpdateData = TestData('remoteUpdateData');
const TestData appStorageData = TestData('appStorageData');
const TestData assetData = TestData('assetData');
const String jsonAssetData = '{"value":"assetData"}';

void mockRemoteData(
        [int delayInMilliseconds = 0, TestData? data = remoteData]) =>
    when(festivalHubMock.loadJsonData('remoteUrl'))
        .thenAnswer(mockOptionalResponse(data, delayInMilliseconds));

void mockPeriodicRemoteData(
    [int delayInMilliseconds = 0, List<TestData?>? dataList]) {
  final responses = dataList
          ?.map((data) => mockOptionalResponse(data, delayInMilliseconds))
          .toList() ??
      [
        mockOptionalResponse(remoteData, delayInMilliseconds),
        mockOptionalResponse(remoteUpdateData, delayInMilliseconds),
      ];
  when(festivalHubMock.loadJsonData('remoteUrl')).thenAnswer((invocation) {
    final response =
        responses.length > 1 ? responses.removeAt(0) : responses.first;
    return response(invocation);
  });
}

void mockAppStorageData(
        [int delayInMilliseconds = 0, TestData? data = appStorageData]) =>
    when(appStorageMock.loadJson('appStorageKey'))
        .thenAnswer(mockOptionalResponse(data, delayInMilliseconds));

void mockAssetData(
    [int delayInMilliseconds = 0, String? data = jsonAssetData]) {
  when(buildContextMock.dependOnInheritedWidgetOfExactType())
      .thenReturn(defaultAssetBundleMock);
  when(defaultAssetBundleMock.bundle).thenReturn(assetBundleMock);
  when(assetBundleMock.loadString('fallbackDataAssetPath')).thenAnswer(
      data != null
          ? mockResponse(data, delayInMilliseconds)
          : mockError<String>(delayInMilliseconds));
}

Future<bool> assertStreamData(List<String> expectedData) async {
  final data = await createStream().toList();
  return assertList(data, expectedData);
}

Future<bool> assertPeriodicStreamData(List<String> expectedData) async {
  final data =
      await createStream(periodicDuration).take(expectedData.length).toList();
  return assertList(data, expectedData);
}

void main() {
  group('CombinedStorageStreamProvider', () {
    setUpAll(() {
      dimeInstall(TestModule());
      // Supress debug prints
      debugPrint = (message, {wrapWidth}) {};
    });

    group('without periodic update', () {
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

    group('with periodic update', () {
      test('resolves remote and updated data only if returned first', () async {
        mockPeriodicRemoteData();
        mockAppStorageData(10);
        expect(
            await assertPeriodicStreamData(['remoteData', 'remoteUpdateData']),
            true);
      });

      test('resolves app storage data before remote and updated data',
          () async {
        mockPeriodicRemoteData(10);
        mockAppStorageData(0);
        expect(
            await assertPeriodicStreamData(
                ['appStorageData', 'remoteData', 'remoteUpdateData']),
            true);
      });

      test(
          'resolves asset data before remote and updated data if app storage'
          'data is missing', () async {
        mockPeriodicRemoteData(20);
        mockAppStorageData(0, null);
        mockAssetData();
        expect(
            await assertPeriodicStreamData(
                ['assetData', 'remoteData', 'remoteUpdateData']),
            true);
      });

      test('resolves remote and updated data only if no fallback was found',
          () async {
        mockPeriodicRemoteData(10);
        mockAppStorageData(0, null);
        mockAssetData(0, null);
        expect(
            await assertPeriodicStreamData(['remoteData', 'remoteUpdateData']),
            true);
      });

      test(
          'resolves app and remote update data only if loading remote data'
          'failed first', () async {
        mockPeriodicRemoteData(0, [null, remoteUpdateData]);
        mockAppStorageData(10);
        expect(
            await assertPeriodicStreamData(
                ['appStorageData', 'remoteUpdateData']),
            true);
      });

      test(
          'resolves app and remote update data only if loading remote data'
          'failed afterwards', () async {
        mockPeriodicRemoteData(10, [null, remoteUpdateData]);
        mockAppStorageData(0);
        expect(
            await assertPeriodicStreamData(
                ['appStorageData', 'remoteUpdateData']),
            true);
      });

      test(
          'resolves asset and remote update data only if loading remote and app'
          'storage data failed first', () async {
        mockPeriodicRemoteData(0, [null, remoteUpdateData]);
        mockAppStorageData(10, null);
        mockAssetData();
        expect(
            await assertPeriodicStreamData(['assetData', 'remoteUpdateData']),
            true);
      });

      test(
          'resolves asset and remote update data only if loading remote and app'
          'storage data failed afterwards', () async {
        mockPeriodicRemoteData(15, [null, remoteUpdateData]);
        mockAppStorageData(10, null);
        mockAssetData();
        expect(
            await assertPeriodicStreamData(['assetData', 'remoteUpdateData']),
            true);
      });

      test('throws error if loading all data failed, offline returned first',
          () async {
        mockPeriodicRemoteData(15, [null, remoteUpdateData]);
        mockAppStorageData(10, null);
        mockAssetData(0, null);
        expect(createStream(periodicDuration).toList(), throwsException);
      });

      test('throws error if loading all data failed, remote returned first',
          () async {
        mockPeriodicRemoteData(0, [null, remoteUpdateData]);
        mockAppStorageData(10, null);
        mockAssetData(0, null);
        expect(createStream(periodicDuration).toList(), throwsException);
      });

      test('ignores errors during periodic remote update', () async {
        mockPeriodicRemoteData(0, [remoteData, null, null, remoteUpdateData]);
        mockAppStorageData(10);
        expect(
            await assertPeriodicStreamData(['remoteData', 'remoteUpdateData']),
            true);
      });
    });
  });
}
