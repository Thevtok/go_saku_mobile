import 'package:go_saku/domain/model/user.dart';

import '../model/abstract/repository/userRepo.dart';
import '../model/abstract/usecase/userUsecase.dart';

class UserUseCaseImpl implements UserUseCase {
  final UserRepository _repository;

  UserUseCaseImpl(this._repository);

  @override
  Future<String?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        // Menampilkan pesan kesalahan jika email atau password kosong
        return 'Email and password are required.';
      }

      return await _repository.login(email, password);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<User>?> findUsers() async {
    try {
      return await _repository.getAll();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<UserResponse?> findByUsername(String username) async {
    try {
      return await _repository.getByUsername(username);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> register(User user) async {
    try {
      if (!user.email.endsWith('@gmail.com')) {
        throw Exception('Invalid email format. Email must end with @gmail.com');
      }

      if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$')
          .hasMatch(user.password)) {
        throw Exception(
            'Invalid password format. Password must have at least 1 uppercase letter, 1 number, and minimum 8 characters');
      }

      if (!RegExp(r'^\d{11,13}$').hasMatch(user.phoneNumber)) {
        throw Exception(
            'Invalid phone number format. Phone number must consist of 11 to 13 digits');
      }

      return await _repository.create(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> edit(User user) async {
    try {
      return await _repository.update(user);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> unreg(int id) async {
    try {
      return await _repository.delete(id);
    } catch (e) {
      return null;
    }
  }
}
