import 'package:go_saku/domain/model/abstract/repository/bankRepo.dart';
import 'package:go_saku/domain/model/abstract/usecase/bankUsecase.dart';

import '../model/bank.dart';

class BankUseCaseImpl implements BankUsecase {
  final BankRepository _repository;

  BankUseCaseImpl(this._repository);

  @override
  Future<List<Bank>?> findByUserID(String id) async {
    return await _repository.getByUserID(id);
  }

  @override
  Future<Bank> findByAccountID(String userId, int accountId) async {
    return await _repository.getByAccountID(userId, accountId);
  }

  @override
  Future<dynamic> add(String id, Bank newBankAcc) async {
    return await _repository.create(id, newBankAcc);
  }

  @override
  Future<String> unregByAccId(String userId, int accountId) async {
    return await _repository.deleteByAccId(userId, accountId);
  }
}
