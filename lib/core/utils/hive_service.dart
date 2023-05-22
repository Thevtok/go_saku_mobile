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

  static Future<bool> hasToken() async {
    final box = await Hive.openBox('auth');
    final token = box.get('token') as String?;

    return token != null;
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

bool isTokenExpired() {
  // Dapatkan waktu saat ini
  DateTime currentTime = DateTime.now();

  DateTime expiryTime = currentTime.add(const Duration(hours: 1));

  if (currentTime.isAfter(expiryTime)) {
    return true;
  } else {
    return false;
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
