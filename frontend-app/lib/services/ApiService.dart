import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://a960-2401-4900-92d0-2d08-25ff-24dc-354f-9d21.ngrok-free.app/api';

  /// Simple GET => List posts
  Future<List<dynamic>> fetchPosts() async {
    final res = await http.get(Uri.parse('$baseUrl/posts'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);          // ✅ success
    } else {
      throw Exception('Failed to load');    // ❌ handle error
    }
  }

  /// Simple POST => Create post
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode  == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to create');
    }
  }
}
