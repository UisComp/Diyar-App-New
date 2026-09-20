import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';

/// A request the app sent.
class RecordedRequest {
  RecordedRequest(this.method, this.path, this.query, this.headers, this.body);

  final String method;

  /// Relative to the API base, e.g. `auth/login`.
  final String path;
  final Map<String, dynamic> query;
  final Map<String, dynamic> headers;

  /// The decoded JSON body, if any.
  final Object? body;

  Map<String, dynamic> get json => (body as Map).cast<String, dynamic>();

  String? get authorization => headers['Authorization']?.toString();
}

class FakeResponse {
  const FakeResponse(this.status, this.body);

  final int status;
  final Object? body;
}

/// Stands in for the backend: the real [DioHelper] talks to it, so tests run
/// the real services, models and controllers.
class FakeApi implements HttpClientAdapter {
  final List<RecordedRequest> requests = [];
  final Map<String, List<FakeResponse Function(RecordedRequest)>> _routes = {};
  final Set<String> _offline = {};

  /// Installs a fresh fake behind [DioHelper].
  static FakeApi install() {
    final api = FakeApi();
    DioHelper.dio =
        Dio(
            BaseOptions(
              baseUrl: ApiPaths.baseUrl,
              validateStatus: (_) => true,
              headers: {'Accept': 'application/json'},
            ),
          )
          ..httpClientAdapter = api
          ..interceptors.add(DioHelper.sessionInterceptor());
    return api;
  }

  /// Answers `METHOD path` with [status] and [body]. Several calls queue up
  /// answers; the last one repeats.
  void on(String method, String path, {int status = 200, Object? body}) =>
      onRequest(method, path, (_) => FakeResponse(status, body));

  void onRequest(
    String method,
    String path,
    FakeResponse Function(RecordedRequest request) handler,
  ) => (_routes['$method $path'] ??= []).add(handler);

  /// The request fails without a response (offline).
  void offline(String method, String path) => _offline.add('$method $path');

  List<RecordedRequest> sent(String method, String path) => [
    for (final r in requests)
      if (r.method == method && r.path == path) r,
  ];

  RecordedRequest last(String method, String path) => sent(method, path).last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    Object? body;
    if (requestStream != null) {
      final bytes = await requestStream.fold<List<int>>(
        [],
        (all, chunk) => all..addAll(chunk),
      );
      final text = utf8.decode(bytes);
      try {
        body = text.isEmpty ? null : jsonDecode(text);
      } catch (_) {
        body = text;
      }
    }
    final path = options.path.startsWith('/')
        ? options.path.substring(1)
        : options.path;
    final request = RecordedRequest(
      options.method,
      path,
      options.queryParameters,
      options.headers,
      body,
    );
    requests.add(request);

    final key = '${options.method} $path';
    if (_offline.contains(key)) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline (fake)',
      );
    }
    final handlers = _routes[key];
    final response = handlers == null
        ? const FakeResponse(404, {'success': false, 'message': 'No route'})
        : (handlers.length > 1 ? handlers.removeAt(0) : handlers.first)(
            request,
          );
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// `{ success: false, message, errors: { code, retry_after? } }`
Map<String, dynamic> apiError(
  String code, {
  String? message,
  int? retryAfter,
}) => {
  'success': false,
  'message': message ?? code,
  'errors': {
    'code': code,
    if (retryAfter != null) 'retry_after': retryAfter,
  },
};

Map<String, dynamic> apiOk(Object? data, {String message = ''}) => {
  'success': true,
  'message': message,
  'data': data,
};
