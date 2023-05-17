// ignore_for_file: file_names

import 'package:go_saku/domain/model/bank.dart';

abstract class BankRepository {
  Future<List<Bank>> getByUserID(int id);

  Future<dynamic> create(int id, Bank newBankAcc);
  Future<String> deleteByAccId(int userId, int accountId);
}
