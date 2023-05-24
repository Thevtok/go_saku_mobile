// ignore_for_file: file_names, non_constant_identifier_names

import 'package:go_saku/domain/model/transaction.dart';

abstract class TransactionRepository {
  Future<String> createDepositBank(
      String user_id, int account_id, DepositBank depositBank);
  Future<String> createTransfer(String user_id, Transfer transfer);
  Future<List<Transaction>?> getByUserID(String id);
  Future<String> withdraw(String user_id, int account_id, Withdraw withdraw);
}
