import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Custom exception so the UI can tell "API error" from random ones.
class ApiException implements Exception {
  final int statusCode;
  final String message;
  ApiException(this.statusCode, this.message);
  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiService {
  static final _baseUrl = '${dotenv.env['API_BASE_URL']!}/api';

  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$_baseUrl/login'),               // <-- your endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('⇢  status  : ${res.statusCode}');
    print('⇢  response: ${res.body}');

    switch (res.statusCode) {
      case 200:
        return jsonDecode(res.body) as Map<String, dynamic>;
      case 403:
        throw ApiException(403, 'Invalid credentials');
      default:
        throw ApiException(res.statusCode, 'Unexpected error');
    }
  }
}
