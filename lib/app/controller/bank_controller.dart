// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../../domain/model/bank.dart';
import '../../domain/repository/bank_repository.dart';
import '../../domain/screens/homepage.dart';
import '../../domain/use_case/bank_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

final apiClient = ApiClient();
final bankRepo = BankRepositoryImpl(apiClient);
final bankUsecase = BankUseCaseImpl(bankRepo);

class BankController {
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController bankAccountNumberController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<void> addBank(BuildContext context) async {
    String bankName = bankNameController.text;
    String accountNumber = bankAccountNumberController.text;
    String name = nameController.text;

    Bank bank = Bank(
      bankName: bankName,
      accountNumber: accountNumber,
      name: name,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CustomCircularProgressIndicator(
          message: 'Loading',
        );
      },
    );

    final id = await getTokenUserId();
    final result = await bankUsecase.add(id!, bank);

    if (result != null) {
      // Berhasil menambahkan bank account
      showCustomDialog(
        context,
        'Success',
        'Berhasil menambahkan bank account',
        () {
          Get.off(const HomePage());
        },
      );
    } else {
      // Gagal menambahkan bank account
      showSnackBar(context, 'Gagal menambahkan bank');
    }
  }

  Future<void> deleteBank(BuildContext context, Bank bank) async {
    int? selectedAccountId = bank.accountId;
    String? selectedUserId = bank.userId;

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Anda yakin ingin menghapus bank ini?'),
          actions: [
            TextButton(
              child: const Text('Ya'),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Mengirim nilai true jika "Ya" ditekan
              },
            ),
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Mengirim nilai false jika "Tidak" ditekan
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomCircularProgressIndicator(
            message: 'Loading',
          );
        },
      );

      final result = await bankUsecase.unregByAccId(
        selectedUserId!,
        selectedAccountId!,
      );

      if (result != null) {
        // Bank berhasil dihapus
        showCustomDialog(
          context,
          'Sukses',
          'Bank berhasil dihapus',
          () {
            Navigator.of(context).pop(); // Tutup dialog
            Get.off(const HomePage()); // Navigasi ke halaman Home
          },
        );
      } else {
        // Gagal menghapus bank
        showSnackBar(context, 'Gagal menghapus bank');
      }
    }
  }
}
