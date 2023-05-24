// ignore_for_file: file_names, non_constant_identifier_names

import '../../transaction.dart';

abstract class TransactionUsecase {
  Future<String> makeDepositBank(
      String user_id, int account_id, DepositBank depositBank);
  Future<String> makeTransfer(String user_id, Transfer transfer);
  Future<List<Transaction>?> findTxByUserID(String id);
  Future<String> createWithdraw(
      String user_id, int account_id, Withdraw withdraw);
}
