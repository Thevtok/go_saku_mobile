// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_saku/core/network/api_user.dart';
import 'package:go_saku/domain/model/user.dart';

import '../../core/utils/hive_service.dart';
import '../model/abstract/repository/userRepo.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<String> create(User user) async {
    final response = await _apiClient.post(
      path: '/register',
      body: user.toJson(),
    );
    if (response['statusCode'] == 201) {
      return 'User created successfully';
    } else {
      throw Exception('Failed to create user');
    }
  }

  @override
  Future<String?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        path: '/login',
        body: {'email': email, 'password': password},
      );

      if (response['statusCode'] == 200) {
        final token = response['result']['token'] as String;

        // Simpan token menggunakan HiveService
        await HiveService.saveToken(token);

        // Mendapatkan token perangkat
        String? deviceToken = await FirebaseMessaging.instance.getToken();

        // Menyertakan token perangkat dalam permintaan login
        await _apiClient.post(
          path: '/login',
          body: {
            'email': email,
            'password': password,
            'token': deviceToken,
          },
        );

        return token;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<User?> getByUsername(String username) async {
    try {
      final token = await HiveService.getToken();
      final response = await _apiClient.get(
        '/user/username/$username',
        headers: {'Authorization': '$token'},
      );

      if (response != null) {
        final user = User.fromJson(response);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<User?> getByPhone(String phone) async {
    try {
      final token = await HiveService.getToken();
      final response = await _apiClient.get(
        '/user/$phone',
        headers: {'Authorization': '$token'},
      );

      if (response != null) {
        final user = User.fromJson(response);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<String> delete(String id) async {
    final response = await _apiClient.delete(path: '/user/$id');
    if (response['statusCode'] == 204) {
      return 'User deleted successfully';
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<List<User>> getAll() async {
    final response = await _apiClient.get('');
    if (response['statusCode'] == 200) {
      final List<dynamic> usersJson = jsonDecode(response['body']);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<String> update(User user) async {
    final response = await _apiClient.put('/user', user.toJson());
    if (response['statusCode'] == 204) {
      return 'User updated successfully';
    } else {
      throw Exception('Failed to update user');
    }
  }
}
