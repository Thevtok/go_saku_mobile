// ignore_for_file: file_names, non_constant_identifier_names

import 'package:go_saku/domain/model/transaction.dart';

abstract class TransactionRepository {
  Future<String> createDepositBank(
      int user_id, int account_id, DepositBank depositBank);
  Future<String> createTransfer(int user_id, Transfer transfer);
  Future<List<Transaction>?> getByUserID(int id);
  Future<String> withdraw(int user_id, int account_id, Withdraw withdraw);
}
