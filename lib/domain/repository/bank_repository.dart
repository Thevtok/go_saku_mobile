// ignore_for_file: unnecessary_null_comparison

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
      final response = await _apiClient.getListBank(
        '/user/bank/$id',
        headers: {'Authorization': '$token'},
      );

      if (response == null) {
        // Respons null, mengembalikan daftar bank kosong
        return [];
      }

      if (response is List) {
        final List<Bank> bankList = List<Bank>.from(
            response.map((bankJson) => Bank.fromJson(bankJson)));
        return bankList;
      } else {
        throw Exception('Invalid response format. Expected List.');
      }
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

  @override
  Future<Bank> getByAccountID(int userId, int accountId) async {
    final token = await HiveService.getToken();
    final response = await _apiClient.get(
      '/user/bank/$userId/$accountId',
      headers: {'Authorization': '$token'},
    );

    if (response != null) {
      final bank = Bank.fromJson(response);
      return bank;
    } else {
      throw Exception('Failed to get bank');
    }
  }
}
