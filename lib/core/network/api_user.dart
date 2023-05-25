import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import '../utils/hive_service.dart';

class ApiClient {
  static const String baseUrl = "http://11.11.203.177:8080";

  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? headers}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$path'), headers: headers);

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(response.body);
      var result = jsonresponse['result'];
      return result;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<String> postWithFormData(String path, File file, String token) async {
    final url = Uri.parse('$baseUrl$path');
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = token;

    request.files.add(await http.MultipartFile.fromPath('photo', file.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<Uint8List?> getPhoto(String path,
      {Map<String, String>? headers}) async {
    const timeoutDuration = Duration(seconds: 10); // Misalnya, timeout 10 detik

    final response = await http
        .get(Uri.parse('$baseUrl$path'), headers: headers)
        .timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 500) {
      // Jika status code 500, mengembalikan null
      return null;
    } else {
      "gagal ambil photo";
    }
    return null;
  }

  Future<dynamic> getListBank(String path,
      {Map<String, String>? headers}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$path'), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<dynamic> getListTx(String path, {Map<String, String>? headers}) async {
    final response =
        await http.get(Uri.parse('$baseUrl$path'), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['result'];
    } else if (response.statusCode == 404) {
      return "Transaction not found";
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  Future<Map<String, dynamic>> post(
      {required String path,
      required Map<String, dynamic> body,
      headers}) async {
    final response = await http.post(Uri.parse('$baseUrl$path'),
        headers: headers, body: jsonEncode(body));

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

  Future<Map<String, dynamic>> delete({
    required String path,
    Map<String, String>? headers,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete data from API');
    }
  }
}

void logout() async {
  await HiveService.deleteToken();
  Get.off(const login_Screnn());
}
