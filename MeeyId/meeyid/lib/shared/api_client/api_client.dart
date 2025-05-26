import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../data_manager/local_storage.dart';
import '../utils/alice.dart';
import 'interceptor.dart';

class ApiClient {
  final LocalStorage localStorage;
  final Dio dio;
  late DioInterceptors _interceptors;

  ApiClient(this.dio, this.localStorage) {
    // Base URL configuration from environment
    dio.options.baseUrl = "${dotenv.get('API_BASE_URL')}/api/";
    dio.options.connectTimeout = const Duration(minutes: 5);
    dio.options.receiveTimeout = const Duration(minutes: 5);

    // Debug log for base URL
    if (kDebugMode) {
      print('🌐 ApiClient initialized with base URL: ${dio.options.baseUrl}');
    }

    // Add pretty logger in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    // Add Alice interceptor for debugging
    final alice = AliceUtils().alice;
    if (alice != null) {
      dio.interceptors.add(alice.getDioInterceptor());
    }

    // Add custom interceptors
    _interceptors = DioInterceptors(localStorage);
    dio.interceptors.add(_interceptors);
  }

  Future<Response<Map<String, dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    final res = await dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
    );
    return res;
  }

  Future<Response<Map<String, dynamic>>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    final res = await dio.put<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: query,
    );
    return res;
  }

  Future<Response<Map<String, dynamic>>> delete(
    String path, {
    Map<String, dynamic>? param,
    Map<String, dynamic>? data,
  }) async {
    final res = await dio.delete<Map<String, dynamic>>(
      path,
      queryParameters: param,
      data: data,
    );
    return res;
  }

  Future<Response<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic>? param,
    CancelToken? cancelToken,
  }) async {
    final res = await dio.get<Map<String, dynamic>>(
      path,
      queryParameters: param,
      cancelToken: cancelToken,
    );
    return res;
  }
}
