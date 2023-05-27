import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _midtransTokenBox = 'midtrans_token_box';
  static const String _redirectUrlBox = 'redirect_url_box';
  static Future<void> init() async {
    await Hive.initFlutter();
  }

  static Future<void> saveMidtransToken(String token) async {
    final box = await Hive.openBox<String>(_midtransTokenBox);
    await box.put('midtrans_token', token);
    await box.close();
  }

  static Future<String?> getMidtransToken() async {
    final box = await Hive.openBox<String>(_midtransTokenBox);
    final token = box.get('midtrans_token');
    await box.close();
    return token;
  }

  static Future<void> saveRedirectUrl(String url) async {
    final box = await Hive.openBox<String>(_redirectUrlBox);
    await box.put('redirect_url', url);
    await box.close();
  }

  static Future<String?> getRedirectUrl() async {
    final box = await Hive.openBox<String>(_redirectUrlBox);
    final url = box.get('redirect_url');
    await box.close();
    return url;
  }

  static Future<void> deleteRedirectUrl() async {
    final box = await Hive.openBox<String>(_redirectUrlBox);
    await box.delete('redirect_url');
    await box.close();
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

Future<String?> getTokenUserId() async {
  String? token = await HiveService.getToken();

  if (token != null && token.isNotEmpty) {
    Map<String, dynamic> decodedToken = json.decode(
        ascii.decode(base64.decode(base64.normalize(token.split('.')[1]))));

    String userId = decodedToken['user_id'];

    return userId;
  }

  return null;
}
