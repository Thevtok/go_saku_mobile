import 'dart:convert';

import 'package:go_saku/core/network/api_client.dart';
import 'package:go_saku/app/domain/model/user.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;

  UserRepositoryImpl(this._apiClient);

  @override
  Future<String> create(User user) async {
    final response =
        await _apiClient.post(path: '/register', body: user.toJson());
    if (response['statusCode'] == 201) {
      return 'User created successfully';
    } else {
      throw Exception('Failed to create user');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await _apiClient
        .post(path: '/login', body: {'email': email, 'password': password});
    if (response['statusCode'] == 200) {
      final userJson = response['data'];
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<String> delete(int id) async {
    final response = await _apiClient.delete('/user/$id');
    if (response['statusCode'] == 204) {
      return 'User deleted successfully';
    } else {
      throw Exception('Failed to delete user');
    }
  }

  @override
  Future<User?> getById(int id) async {
    final response = await _apiClient.get('/user/$id');
    if (response['statusCode'] == 200) {
      final dynamic userJson = jsonDecode(response['body']);
      return User.fromJson(userJson);
    } else if (response['statusCode'] == 404) {
      return null;
    } else {
      throw Exception('Failed to get user');
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
