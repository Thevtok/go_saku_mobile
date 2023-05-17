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
      int user_id, int account_id, DepositBank depositBank) async {
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
}