import 'package:go_saku/app/domain/model/user.dart';

class UserUseCaseImpl implements UserUseCase {
  final UserRepository _repository;

  UserUseCaseImpl(this._repository);

  @override
  Future<User?> login(String email, String password) async {
    try {
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
  Future<User?> findById(int id) async {
    try {
      return await _repository.getById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> register(User user) async {
    try {
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
