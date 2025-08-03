import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immortal/immortal.dart';
import 'package:lilafestivalapp/models/app_route.dart';

import '../test_data.dart';

void main() {
  group('nested app route', () {
    test('create correct route path', () {
      final nestedAppRoute = NestedAppRoute(
        path: '/history',
        getName: () => '',
        icon: Icons.history,
        nestedRouteBuilder: (_, _) => Container(),
        nestedRoutes: ImmortalList.empty(),
      );
      final nestedRoute = testFestivalConfig.history.first;

      expect(
        nestedAppRoute.nestedRoutePath(nestedRoute),
        '/history/festival_id_2024',
      );
    });
  });
}
