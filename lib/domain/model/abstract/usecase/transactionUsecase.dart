// ignore_for_file: file_names, non_constant_identifier_names

import '../../transaction.dart';

abstract class TransactionUsecase {
  Future<String> makeDepositBank(
      int user_id, int account_id, DepositBank depositBank);
  Future<String> makeTransfer(int user_id, Transfer transfer);
  Future<List<Transaction>?> findTxByUserID(int id);
  Future<String> createWithdraw(int user_id, int account_id, Withdraw withdraw);
}
