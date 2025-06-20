import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';

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
  Future<Map<String, dynamic>> createPost(Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode  == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Failed to create');
    }
  }
}
