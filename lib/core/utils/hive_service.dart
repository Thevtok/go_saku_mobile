import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<void> saveToken(String token) async {
    final box = await Hive.openBox('auth');
    await box.put('token', token);
  }

  static Future<void> saveUsername(String username) async {
    final box = await Hive.openBox('auth');
    await box.put('username', username);
  }

  static Future<String?> getToken() async {
    final box = await Hive.openBox('auth');
    return box.get('token');
  }

  static Future<String?> getUsername() async {
    final box = await Hive.openBox('auth');
    return box.get('username');
  }

  static Future<void> deleteToken() async {
    final box = await Hive.openBox('auth');
    await box.delete('token');
  }
}

Future<String?> getTokenUsername() async {
  // Dapatkan token dari Hive
  String? token = await HiveService.getToken();

  // Periksa apakah token tidak kosong
  if (token != null && token.isNotEmpty) {
    // Dekode dan verifikasi token JWT untuk mendapatkan klaim-klaim yang terkait
    Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split('.')[1]))));

    // Ambil nilai 'username' dari klaim-klaim yang telah didekode
    String username = decodedToken['username'];

    return username;
  }

  return null;
}

Future<int?> getTokenUserId() async {
  String? token = await HiveService.getToken();

  if (token != null && token.isNotEmpty) {
    Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split('.')[1]))));

    int userId = decodedToken['user_id'];

    return userId;
  }

  return null;
}
