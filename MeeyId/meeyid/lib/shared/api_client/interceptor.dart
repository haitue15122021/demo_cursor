import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as prefix;
import '../data_manager/local_storage.dart';
import '../../constants/index.dart';

class DioInterceptors extends InterceptorsWrapper {
  final LocalStorage _localStorage;
  bool? showLoading;

  DioInterceptors(this._localStorage);

  @override
  Future<RequestOptions> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);

    final String token = await _localStorage.get(AppConstants.tokenKey) ?? '';
    final headers = <String, dynamic>{};

    headers["locale"] = prefix.Get.locale?.languageCode ?? 'en';
    headers["client-name"] = AppConstants.appName;
    headers["client-key"] = "meeyid-client-key";
    headers["Content-Type"] = 'application/json';
    headers['Authorization'] = 'Bearer $token';

    if (kDebugMode) {
      debugPrint('TOKEN: $token');
      debugPrint('client-key: meeyid-client-key');
    }

    if (token.isNotEmpty) {
      headers["access_token"] = token;
    }

    options.headers.addAll(headers);

    if (kDebugMode) {
      /// Log CURL
      log('>>>>>>>>CURL:\n ${options.toCURL()}');
    }

    return options;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    // Handle loading dismissal here if needed
    if (kDebugMode) {
      debugPrint('DIO Error: ${err.message}');
    }
  }

  Future<Response> retryToken(Response response) async {
    return response;
  }
}

// Extension to generate CURL command for debugging
extension RequestOptionsCURL on RequestOptions {
  String toCURL() {
    String curl = 'curl -X $method';

    // Add headers
    headers.forEach((key, value) {
      curl += ' -H "$key: $value"';
    });

    // Add data for POST/PUT requests
    if (data != null && (method == 'POST' || method == 'PUT')) {
      curl += ' -d \'$data\'';
    }

    // Add query parameters
    if (queryParameters.isNotEmpty) {
      final queryString = queryParameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      curl += ' "$uri?$queryString"';
    } else {
      curl += ' "$uri"';
    }

    return curl;
  }
}
