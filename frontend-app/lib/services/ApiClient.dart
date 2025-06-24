import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late final Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: '${dotenv.env['API_BASE_URL']!}/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("🔄 Interceptor triggered for: ${options.path}");

          try {
            final prefs = await SharedPreferences.getInstance();

            final token = prefs.getString('token');
            final hospitalId = prefs.getString('hospital_id');
            final role = prefs.getString('role');
            final userId = prefs.getString('user_id');

            print("🔑 Token: ${token != null ? 'Present' : 'Missing'}");
            print("🏥 Hospital ID: $hospitalId");
            print("👤 Role: $role");
            print("🆔 User ID: $userId");

            if (token != null && token.isNotEmpty) {
              options.headers["Authorization"] = "Bearer $token";
              print("✅ Authorization header added");
            } else {
              print("⚠️ No token found - skipping Authorization header");
            }

            // Only transform if it's a relative path
            if (hospitalId != null && role != null && userId != null) {
              final originalPath = options.path;
              options.path = '/hospital/$hospitalId/$role/$userId$originalPath';
              print("🔄 Path transformed: $originalPath → ${options.path}");
            } else {
              print("ℹ️ Path not transformed. Conditions:");
              print(
                "  - Starts with /hospital/: ${options.path.startsWith('/hospital/')}",
              );
              print("  - Hospital ID present: ${hospitalId != null}");
              print("  - Role present: ${role != null}");
              print("  - User ID present: ${userId != null}");
            }

            final fullUrl = '${_dio.options.baseUrl}${options.path}';
            print("➡️ [${options.method}] $fullUrl");
            if (options.data != null) print("📤 Body: ${options.data}");
            if (options.queryParameters?.isNotEmpty == true) {
              print("🔍 Query: ${options.queryParameters}");
            }

            handler.next(options);
          } catch (e) {
            print("❌ Error in request interceptor: $e");
            handler.next(options);
          }
        },
        onResponse: (response, handler) {
          print("✅ [${response.statusCode}] ${response.requestOptions.uri}");
          print("📥 Response: ${response.data}");
          handler.next(response);
        },
        onError: (DioException e, handler) {
          final status = e.response?.statusCode ?? 'No Status';
          print("❌ [$status] ${e.requestOptions.uri}");
          print("🧨 Error: ${e.message}");
          if (e.response?.data != null) {
            print("📥 Error Response: ${e.response?.data}");
          }
          handler.next(e);
        },
      ),
    );
  }

  /// GET request with auto-context
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    print("🚀 Making GET request to: $path");
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      print("💥 GET request failed: ${e.message}");
      throw _handleError(e);
    }
  }

  /// POST request with auto-context
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    print("🚀 Making POST request to: $path");
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      print("💥 POST request failed: ${e.message}");
      throw _handleError(e);
    }
  }

  /// Optional PUT and DELETE
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    print("🚀 Making PUT request to: $path");
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      print("💥 PUT request failed: ${e.message}");
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    print("🚀 Making DELETE request to: $path");
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      print("💥 DELETE request failed: ${e.message}");
      throw _handleError(e);
    }
  }

  /// Common error handler
  Exception _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? e.message;
    final status = e.response?.statusCode;
    print("🔥 Handling error: [$status] $message");
    return Exception("API Error [$status]: $message");
  }

  // Debug method to check stored values
  Future<void> debugStoredValues() async {
    final prefs = await SharedPreferences.getInstance();
    print("🔍 DEBUG - Stored values:");
    print("  Token: ${prefs.getString('token')}");
    print("  Hospital ID: ${prefs.getString('hospital_id')}");
    print("  Role: ${prefs.getString('role')}");
    print("  User ID: ${prefs.getString('user_id')}");
    print("  Base URL: ${dotenv.env['API_BASE_URL']}");
  }
}
