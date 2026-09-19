// A 401 for the signed-in user's own token signs them out
// (MOBILE-API-CHANGES-MASTER-PLAN-2026-09-19.md §4.1).
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_env.dart';
import '../helpers/fake_api.dart';

void main() {
  late FakeApi api;
  var expired = 0;

  setUp(() async {
    api = await setUpAuthTestEnv();
    expired = 0;
    DioHelper.onSessionExpired = () async => expired++;
  });
  tearDown(() => DioHelper.onSessionExpired = null);

  const unauthenticated = {'message': 'Unauthenticated.'};

  test('the user\'s own token rejected → session expired', () async {
    await signIn();
    api.on('GET', 'projects/1', status: 401, body: unauthenticated);

    await DioHelper.getData(path: ApiPaths.getProjectDetails(id: '1'));

    expect(expired, 1);
  });

  test('a 401 while signed out (e.g. a unit\'s news) is not', () async {
    api.on('GET', 'news/unit/5', status: 401, body: unauthenticated);

    await DioHelper.getData(path: 'news/unit/5');

    expect(expired, 0);
  });

  test('a 401 for another token (password setup) is not', () async {
    await signIn();
    api.on('POST', ApiPaths.setPassword, status: 401, body: unauthenticated);

    await DioHelper.postData(
      path: ApiPaths.setPassword,
      needHeader: false,
      headers: {'Authorization': 'Bearer setup-token'},
    );

    expect(expired, 0);
  });

  test('logging out with a dead token is left to the logout flow', () async {
    await signIn();
    api.on('POST', ApiPaths.logOut, status: 401, body: unauthenticated);

    await DioHelper.postData(path: ApiPaths.logOut);

    expect(expired, 0);
  });

  test('other errors are not', () async {
    await signIn();
    api.on(
      'GET',
      'units/9',
      status: 403,
      body: {'success': false, 'message': 'Unauthorized to access this unit.'},
    );

    await DioHelper.getData(path: ApiPaths.getUnitById(id: '9'));

    expect(expired, 0);
  });
}
