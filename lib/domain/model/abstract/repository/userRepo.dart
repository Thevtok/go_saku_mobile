// ignore_for_file: file_names

import '../../user.dart';

abstract class UserRepository {
  Future<String?> login(String email, String password);
  Future<List<User>> getAll();
  Future<User?> getByUsername(String username);
  Future<User?> getByPhone(String phone);
  Future<String> create(User user);
  Future<String> update(User user);
  Future<String> delete(String id);
}
