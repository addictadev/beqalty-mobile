import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../services/shared_preferences_service.dart';
import '../../utils/shared_prefs_helper.dart';
import '../../navigation_services/navigation_manager.dart';
import '../../utils/custom_new_toast.dart';
import '../../di/service_locator.dart';

import 'package:palestine_console/palestine_console.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../end points/end_points.dart';

class ApiResponse<T> {
  final T? data;
  final bool status;
  final String? message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiResponse({
    this.data,
    required this.status,
    this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse(
      data: data,
      status: true,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(
    String message, {
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      status: false,
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;
  final DioException? originalException;

  ApiException({
    required this.message,
    this.statusCode,
    this.errors,
    this.originalException,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class DioHelper {
  factory DioHelper() => _instance;
  DioHelper._();
  static final DioHelper _instance = DioHelper._();

  static Dio? _dio;
  static const int _connectionTimeout = 60;
  static const int _receiveTimeout = 60;
  static bool _isNetworkStable = true;
  static Timer? _networkStabilityTimer;

  static Future<void> init() async {
    _dio = Dio(
      BaseOptions(
        baseUrl: EndPoints.baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: _connectionTimeout),
        receiveTimeout: const Duration(seconds: _receiveTimeout),
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    _dio!.interceptors.addAll([
      _createAuthInterceptor(),
      _createLoggingInterceptor(),
    ]);
  }

  static Dio get dio {
    if (_dio == null) {
      init();
    }
    return _dio!;
  }

  static Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Accept'] = 'application/json';
        options.headers['Content-Type'] = 'application/json';
        options.headers['Accept-Language'] =
            ServiceLocator.get<SharedPreferencesService>().getLanguage();

        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        Print.red('🚨 Interceptor caught error: ${e.response?.statusCode}');
        if (e.response?.statusCode == 401) {
          Print.red('🔐 401 Unauthorized detected in interceptor');
          _handleUnauthorizedError();

          return handler.resolve(
            Response(
              requestOptions: e.requestOptions,
              statusCode: 401,
              data: {'status': false, 'message': 'unauthorized_request'.tr()},
            ),
          );
        }
        return handler.next(e);
      },
    );
  }

  static Interceptor _createLoggingInterceptor() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
    );
  }

  static bool _isHandlingUnauthorized = false;

  static void _handleUnauthorizedError() {
    if (_isHandlingUnauthorized) {
      Print.yellow('⚠️ Already handling unauthorized error, skipping...');
      return;
    }

    _isHandlingUnauthorized = true;
    Print.red('🔐 Handling unauthorized error - navigating to login');

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final sharedPref = ServiceLocator.get<SharedPreferencesService>();
        await sharedPref.clearAll();

        if (NavigationManager.navigatorKey.currentContext != null) {
          Print.green('📱 Showing session expired dialog');
          _showSessionExpiredDialog();
        } else {
          Print.green('📱 Navigating directly to login view');
          // NavigationManager.navigateToAndFinish(LoginView());
        }
      } catch (e) {
        Print.red('❌ Error in _handleUnauthorizedError: $e');
      } finally {
        Future.delayed(const Duration(seconds: 2), () {
          _isHandlingUnauthorized = false;
        });
      }
    });
  }

  static void _showSessionExpiredDialog() {
    showDialog(
      context: NavigationManager.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              Text(
                'session_expired_title'.tr(),
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: GoogleFonts.cairo().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            // PrimaryButton(
            //   fontSize: 14,
            //   text: 'login_button'.tr(),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //     NavigationManager.navigateToAndFinish(LoginView());
            //   },
            // ),
          ],
        );
      },
    );
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      final isConnected = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      _updateNetworkStability(isConnected);

      return isConnected;
    } on SocketException catch (_) {
      _updateNetworkStability(false);
      return false;
    }
  }

  static void _updateNetworkStability(bool isConnected) {
    if (!isConnected && _isNetworkStable) {
      _isNetworkStable = false;
      _showNetworkUnstableMessage();
    } else if (isConnected && !_isNetworkStable) {
      _isNetworkStable = true;
      _showNetworkRestoredMessage();
    }
  }

  static void _showNetworkUnstableMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DioHelper.showWarningToast('network_unstable'.tr());
    });
  }

  static void _showNetworkRestoredMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DioHelper.showSuccessToast('network_restored'.tr());
    });
  }

  static Map<String, String> getHeaders({String? token}) {
    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Accept-Language": ServiceLocator.get<SharedPreferencesService>()
          .getLanguage(),
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  static Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'GET',
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    bool requiresAuth = true,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'PATCH',
      data: data,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
      fromJson: fromJson,
    );
  }

  static Future<ApiResponse<T>> _request<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = false,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final bool isConnected = await hasInternetConnection();
      if (!isConnected) {
        return ApiResponse.error('no_internet_connection'.tr());
      }

      final token = await SharedPrefsHelper.getUserToken();

      if (requiresAuth && (token == null || token.isEmpty)) {
        _handleUnauthorizedError();
        return ApiResponse.error('unauthorized_request'.tr(), statusCode: 401);
      }

      final options = Options(
        method: method,
        headers: getHeaders(token: requiresAuth ? token : null),
      );

      final response = await dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      Print.green('✅ Success Response: ${response.data}');
      Print.cyan('📍 Endpoint: $path');

      if (response.data is Map<String, dynamic> &&
          response.data['status'] == false) {
        Print.red('❌ Response body indicates error: ${response.data}');
        Print.red('📊 Response status code: ${response.statusCode}');
        return _handleResponseError<T>(response, path);
      }

      T? parsedData;
      if (fromJson != null && response.data != null) {
        try {
          parsedData = fromJson(response.data);
        } catch (e) {
          Print.red('❌ Error parsing response: $e');
          return ApiResponse.error('error_parsing_response'.tr());
        }
      } else {
        parsedData = response.data as T?;
      }

      return ApiResponse.success(
        parsedData as T,
        message: response.data['message'],
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return _handleDioException<T>(e, path);
    } catch (e) {
      Print.red('❌ Unexpected error: $e');
      return ApiResponse.error('an_unknown_error_occurred'.tr());
    }
  }

  static ApiResponse<T> _handleDioException<T>(DioException e, String path) {
    Print.red('❌ DioException: ${e.message}');
    Print.red('📍 Endpoint: $path');

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiResponse.error('request_timeout'.tr());
    }

    if (e.type == DioExceptionType.connectionError) {
      _handleNetworkSwitchingIssue();
      return ApiResponse.error('network_switching_error'.tr());
    }

    if (e.type == DioExceptionType.cancel) {
      _handleNetworkSwitchingIssue();
      return ApiResponse.error('network_switching_error'.tr());
    }

    if (e.response != null) {
      return _handleResponseError<T>(e.response!, path);
    }

    return ApiResponse.error('an_unknown_error_occurred'.tr());
  }

  static void _handleNetworkSwitchingIssue() {
    _networkStabilityTimer?.cancel();

    _networkStabilityTimer = Timer(const Duration(seconds: 3), () async {
      final isConnected = await hasInternetConnection();
      if (isConnected) {
        _showNetworkRestoredMessage();
      } else {
        _showNetworkUnstableMessage();
      }
    });
  }

  static ApiResponse<T> _handleResponseError<T>(
    Response response,
    String path,
  ) {
    final statusCode = response.statusCode;
    final responseData = response.data;

    Print.red('📊 Status Code: $statusCode');
    Print.red('📄 Response Data: $responseData');

    if (responseData is String && responseData.toString().contains('<html>')) {
      return ApiResponse.error('unexpected_server_response'.tr());
    }

    String? message;
    Map<String, dynamic>? errors;

    if (responseData is Map<String, dynamic>) {
      message = responseData['message'];
      errors = responseData['errors'] as Map<String, dynamic>?;
    }

    switch (statusCode) {
      case 400:
        return ApiResponse.error(
          message ?? 'bad_request'.tr(),
          statusCode: statusCode,
          errors: errors,
        );

      case 401:
        Print.red('🔐 401 Unauthorized detected in _handleResponseError');

        _handleUnauthorizedError();
        return ApiResponse.error(
          message ?? 'unauthorized_request'.tr(),
          statusCode: statusCode,
        );

      case 403:
        return ApiResponse.error(
          message ?? 'forbidden_access'.tr(),
          statusCode: statusCode,
        );

      case 404:
        return ApiResponse.error(
          message ?? 'requested_resource_not_found'.tr(),
          statusCode: statusCode,
        );

      case 409:
        return ApiResponse.error(
          message ?? 'conflict_error'.tr(),
          statusCode: statusCode,
        );

      case 422:
        return ApiResponse.error(
          message ?? 'invalid_request_parameters'.tr(),
          statusCode: statusCode,
          errors: errors,
        );

      case 429:
        return ApiResponse.error(
          message ?? 'too_many_requests'.tr(),
          statusCode: statusCode,
        );

      case 500:
      case 502:
        return ApiResponse.error(
          message ?? 'server_error_occurred'.tr(),
          statusCode: statusCode,
        );

      case 503:
        return ApiResponse.error(
          message ?? 'service_unavailable'.tr(),
          statusCode: statusCode,
        );

      case 504:
        return ApiResponse.error(
          message ?? 'gateway_timeout'.tr(),
          statusCode: statusCode,
        );

      default:
        return ApiResponse.error(
          message ?? 'unknown_error_occurred'.tr(),
          statusCode: statusCode,
        );
    }
  }

  static Future<void> showErrorToast(String message) async {
    await ToastHelper.showToast(message, type: MessageType.error);
  }

  static Future<void> showSuccessToast(String message) async {
    await ToastHelper.showToast(message, type: MessageType.success);
  }

  static Future<void> showWarningToast(String message) async {
    await ToastHelper.showToast(message, type: MessageType.warning);
  }

  static Future<void> handleApiResponse<T>(
    ApiResponse<T> response, {
    String? successMessage,
    bool showSuccessToast = false,
    bool showErrorToast = true,
  }) async {
    if (response.status) {
      if (showSuccessToast && successMessage != null) {
        await DioHelper.showSuccessToast(successMessage);
      }
    } else {
      if (showErrorToast) {
        await DioHelper.showErrorToast(
          response.message ?? 'an_error_occurred'.tr(),
        );
      }
    }
  }
}
