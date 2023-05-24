// ignore_for_file: file_names

import '../../bank.dart';

abstract class BankUsecase {
  Future<List<Bank>?> findByUserID(String id);
  Future<Bank> findByAccountID(String userId, int accountId);

  Future<dynamic> add(String id, Bank newBankAcc);
  Future<String> unregByAccId(String userId, int accountId);
}
