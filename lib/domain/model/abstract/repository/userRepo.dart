// ignore_for_file: file_names

import '../../user.dart';

abstract class UserRepository {
  Future<String?> login(String email, String password);
  Future<List<User>> getAll();
  Future<UserResponse?> getByUsername(String username);
  Future<String> create(User user);
  Future<String> update(User user);
  Future<String> delete(int id);
}
