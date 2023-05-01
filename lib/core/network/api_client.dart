import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://11.11.254.187';

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl$path'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<Map<String, dynamic>> post({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data to API');
    }
  }

  Future<Map<String, dynamic>> put(
      String path, Map<String, dynamic> body) async {
    final response = await http.put(Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to put data to API');
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await http.delete(Uri.parse('$baseUrl$path'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data from API');
    }
  }
}
