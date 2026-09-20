import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/api_request.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/api_result.dart';
import 'package:diyar_app/feature/auth/model/phone_auth_models.dart';
import 'package:diyar_app/feature/phone_numbers/model/phone_numbers_models.dart';

/// The signed-in resident's numbers. Adding, replacing and removing are
/// requests that staff approve; switching the primary number is immediate.
class PhoneNumbersService {
  static Future<ApiResult<PhoneNumbersOverview>> getPhones() => apiRequest(
    'GET ${ApiPaths.phones}',
    () => DioHelper.getData(path: ApiPaths.phones),
    parse: PhoneNumbersOverview.fromJson,
  );

  /// Texts a code to the **new** number, before an add or replace.
  static Future<ApiResult<OtpSent>> sendCode({required String phone}) =>
      apiRequest(
        'POST ${ApiPaths.phonesOtp}',
        () => DioHelper.postData(
          path: ApiPaths.phonesOtp,
          data: {'phone': phone},
        ),
        parse: OtpSent.fromJson,
      );

  /// [phone] and [code] for add and replace; [phoneId] for replace and
  /// remove.
  static Future<ApiResult<PhoneChangeRequest>> createRequest({
    required PhoneChangeType type,
    String? phone,
    int? phoneId,
    String? code,
  }) => apiRequest(
    'POST ${ApiPaths.phoneRequests}',
    () => DioHelper.postData(
      path: ApiPaths.phoneRequests,
      data: {
        'type': type.name,
        if (phone != null) 'phone': phone,
        if (phoneId != null) 'phone_id': phoneId,
        if (code != null) 'code': code,
      },
    ),
    parse: PhoneChangeRequest.fromJson,
  );

  static Future<ApiResult<PhoneChangeRequest>> cancelRequest(int id) =>
      apiRequest(
        'DELETE ${ApiPaths.phoneRequest(id)}',
        () => DioHelper.deletData(path: ApiPaths.phoneRequest(id)),
        parse: PhoneChangeRequest.fromJson,
      );

  static Future<ApiResult<PhoneNumbersOverview>> makePrimary(int phoneId) =>
      apiRequest(
        'PATCH ${ApiPaths.makePhonePrimary(phoneId)}',
        () => DioHelper.patchData(path: ApiPaths.makePhonePrimary(phoneId)),
        parse: PhoneNumbersOverview.fromJson,
      );
}
