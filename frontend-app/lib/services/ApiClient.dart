import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();

  late final Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: '${dotenv.env['API_BASE_URL']!}/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          final token = prefs.getString('token');
          final hospitalId = prefs.getString('hospital_id');
          final role = prefs.getString('role');
          final userId = prefs.getString('user_id');

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }

          // Only transform if it's a relative path
          if (!options.path.startsWith('/hospital/') &&
              hospitalId != null &&
              role != null &&
              userId != null) {
            final originalPath = options.path;
            options.path = '/hospital/$hospitalId/$role/$userId$originalPath';
          }

          print("➡️ [${options.method}] ${options.uri}");
          if (options.data != null) print("📤 Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ [${response.statusCode}] ${response.requestOptions.uri}");
          print("📥 Response: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          final status = e.response?.statusCode ?? 'No Status';
          print("❌ [$status] ${e.requestOptions.uri}");
          print("🧨 Error: ${e.message}");
          return handler.next(e);
        },
      ),
    );
  }

  /// GET request with auto-context
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request with auto-context
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Optional PUT and DELETE
  Future<Response> put(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Common error handler
  Exception _handleError(DioException e) {
    final message = e.response?.data?['message'] ?? e.message;
    final status = e.response?.statusCode;
    return Exception("API Error [$status]: $message");
  }
}