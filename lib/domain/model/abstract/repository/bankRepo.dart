// ignore_for_file: file_names

import 'package:go_saku/domain/model/bank.dart';

abstract class BankRepository {
  Future<List<Bank>?> getByUserID(String id);
  Future<Bank> getByAccountID(String userId, int accountId);

  Future<dynamic> create(String id, Bank newBankAcc);
  Future<String> deleteByAccId(String userId, int accountId);
}
