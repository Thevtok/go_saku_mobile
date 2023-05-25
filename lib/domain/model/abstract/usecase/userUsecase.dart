// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';

import '../../user.dart';

abstract class UserUseCase {
  Future<String?> login(String email, String password);
  Future<List<User>?> findUsers();
  Future<User?> findByUsername(String username);
  Future<User?> findByPhone(String phone);
  Future<String?> register(User user);
  Future<String?> edit(User user);
  Future<String?> unreg(String id);
  Future<Uint8List?> getPhoto(String id);
  Future<String> postWithFormData(String id, File file);
}
