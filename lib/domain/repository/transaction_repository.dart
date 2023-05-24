// ignore_for_file: non_constant_identifier_names

import 'package:go_saku/domain/model/abstract/repository/transactionRepo.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final ApiClient _apiClient;
  TransactionRepositoryImpl(this._apiClient);

  @override
  Future<String> createDepositBank(
      String user_id, int account_id, DepositBank depositBank) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.post(
      path: '/user/tx/depo/bank/$user_id/$account_id',
      body: depositBank.toJson(),
      headers: {'Authorization': '$token'},
    );
    if (response['statusCode'] == 201) {
      return 'create deposit bank successfully';
    } else {
      throw Exception('Failed to deposit bank');
    }
  }

  @override
  Future<String> withdraw(
      String user_id, int account_id, Withdraw withdraw) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.post(
      path: '/user/tx/wd/$user_id/$account_id',
      body: withdraw.toJson(),
      headers: {'Authorization': '$token'},
    );
    if (response['statusCode'] == 201) {
      return 'withdraw to bank successfully';
    } else {
      throw Exception('Failed to withdraw');
    }
  }

  @override
  Future<String> createTransfer(String user_id, Transfer transfer) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.post(
      path: '/user/tx/tf/$user_id',
      body: transfer.toJson(),
      headers: {'Authorization': '$token'},
    );
    if (response['statusCode'] == 201) {
      return 'create transfer successfully';
    } else {
      throw Exception('Failed to transfer');
    }
  }

  @override
  Future<List<Transaction>?> getByUserID(String id) async {
    try {
      final token = await HiveService.getToken();
      final response = await _apiClient.getListTx(
        '/user/tx/$id',
        headers: {'Authorization': '$token'},
      );
      if (response == "Transaction not found") {
        // Respons null, mengembalikan daftar bank kosong
        return [];
      }
      final List<Transaction> transactionList = response
          .map<Transaction>((json) => Transaction.fromJson(json))
          .toList();
      return transactionList;
    } catch (e) {
      throw Exception('Failed to get tx list: $e');
    }
  }
}
