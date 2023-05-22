// ignore_for_file: non_constant_identifier_names

import 'package:go_saku/domain/model/abstract/repository/transactionRepo.dart';
import 'package:go_saku/domain/model/abstract/usecase/transactionUsecase.dart';

import '../model/transaction.dart';

class TransactionUsecaseImpl implements TransactionUsecase {
  final TransactionRepository transactionRepository;
  TransactionUsecaseImpl(this.transactionRepository);

  @override
  Future<String> makeDepositBank(
      int user_id, int account_id, DepositBank depositBank) async {
    return await transactionRepository.createDepositBank(
        user_id, account_id, depositBank);
  }

  @override
  Future<String> createWithdraw(
      int user_id, int account_id, Withdraw withdraw) async {
    return await transactionRepository.withdraw(user_id, account_id, withdraw);
  }

  @override
  Future<String> makeTransfer(int user_id, Transfer transfer) async {
    return await transactionRepository.createTransfer(user_id, transfer);
  }

  @override
  Future<List<Transaction>?> findTxByUserID(int id) async {
    return await transactionRepository.getByUserID(id);
  }
}
