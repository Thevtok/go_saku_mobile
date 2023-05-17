import 'package:go_saku/domain/model/abstract/repository/bankRepo.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/bank.dart';

class BankRepositoryImpl implements BankRepository {
  final ApiClient _apiClient;
  BankRepositoryImpl(this._apiClient);

  @override
  Future<String> create(int id, Bank newBankAcc) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.post(
      path: '/user/bank/add/$id',
      body: newBankAcc.toJson(),
      headers: {'Authorization': '$token'},
    );
    if (response['statusCode'] == 201) {
      return 'add bank successfully';
    } else {
      throw Exception('Failed to add bank');
    }
  }

  @override
  Future<List<Bank>> getByUserID(int id) async {
    try {
      final token = await HiveService.getToken();
      final response = await _apiClient.getList(
        '/user/bank/$id',
        headers: {'Authorization': '$token'},
      );
      final List<Bank> bankList =
          response.map((bankJson) => Bank.fromJson(bankJson)).toList();
      return bankList;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<String> deleteByAccId(int userId, int accountId) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.delete(
      path: '/user/bank/$userId/$accountId',
      headers: {'Authorization': '$token'},
    );

    if (response['statusCode'] == 200) {
      return 'Bank deleted successfully';
    } else {
      throw Exception('Failed to delete bank');
    }
  }
}
