// ignore_for_file: file_names

import '../../bank.dart';

abstract class BankUsecase {
  Future<List<Bank>> findByUserID(int id);

  Future<dynamic> add(int id, Bank newBankAcc);
  Future<String> unregByAccId(int userId, int accountId);
}
