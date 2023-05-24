// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../../domain/model/bank.dart';
import '../../domain/model/transaction.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/transaction_repository.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/screens/history_screen.dart';
import '../../domain/use_case/transaction_usecase.dart';
import '../../domain/use_case/user_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

final apiClient = ApiClient();
final txRepo = TransactionRepositoryImpl(apiClient);
final txUsecase = TransactionUsecaseImpl(txRepo);
final userRepo = UserRepositoryImpl(apiClient);
final userUsecase = UserUseCaseImpl(userRepo);

class TransactionController {
  // ...
  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  Future<void> makeDeposit(BuildContext context, Bank bank) async {
    int? selectedAccountId = bank.accountId;

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Jumlah deposit',
            ),
          ),
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

      int? amount = int.tryParse(amountController.text);
      DepositBank deposit = DepositBank(
        accountHolderName: bank.name,
        amount: amount,
        bankName: bank.bankName,
        accountNumber: bank.accountNumber,
      );

      final result = await txUsecase.makeDepositBank(
        bank.userId!,
        selectedAccountId!,
        deposit,
      );

      if (result != null) {
        // Deposit berhasil
        showCustomDialog(
          context,
          'Sukses',
          'Deposit Bank Sukses',
          () {
            Navigator.of(context).pop(); // Tutup dialog
            Get.off(const HistoryPage()); // Navigasi ke halaman History
          },
        );
      } else {
        // Gagal melakukan deposit
        showSnackBar(context, 'Gagal deposit bank');
      }
    }
  }

  Future<void> withdraw(BuildContext context, Bank bank) async {
    int? selectedAccountId = bank.accountId;
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: amountController,
            decoration: const InputDecoration(
              labelText: 'Jumlah withdraw',
            ),
          ),
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
      int? amount = int.tryParse(amountController.text);
      Withdraw withdraw = Withdraw(
        accountHolderName: bank.name,
        amount: amount,
        bankName: bank.bankName,
        accountNumber: bank.accountNumber,
      );

      final result = await txUsecase.createWithdraw(
        bank.userId!,
        selectedAccountId!,
        withdraw,
      );

      if (result != null) {
        // Withdraw berhasil
        showCustomDialog(
          context,
          'Sukses',
          'Withdraw to Bank Sukses',
          () {
            Navigator.of(context).pop(); // Tutup dialog
            Get.off(const HistoryPage()); // Navigasi ke halaman History
          },
        );
      } else {
        // Gagal melakukan withdraw
        showSnackBar(context, 'Gagal withdraw to bank');
      }
    }
  }

  Future<void> makeTransfer(BuildContext context, User user) async {
    final String phoneNumber = phoneController.text;
    int? amount = int.tryParse(amountController.text);
    final recipient = await userUsecase.findByPhone(phoneNumber);
    final id = await getTokenUserId();

    if (recipient == null) {
      showSnackBar(context, 'Recipient not found');
      return;
    }

    bool confirmed = false;
    if (!confirmed) {
      final confirmedResult = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Transfer'),
            content: Text(
                'Are you sure you want to transfer $amount to ${recipient.username}?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (confirmedResult == null || !confirmedResult) {
        return;
      } else {
        confirmed = true;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CustomCircularProgressIndicator(
          message: 'Loading',
        );
      },
    );

    Transfer transfer = Transfer(
      senderName: user.username,
      senderPhone: user.phoneNumber,
      recipientName: recipient.username,
      recipientPhone: phoneNumber,
      amount: amount,
    );

    final result = await txUsecase.makeTransfer(id!, transfer);

    if (result != null) {
      // Transfer berhasil
      showCustomDialog(
        context,
        'Success',
        'Transfer successfully',
        () {
          Navigator.of(context).pop();
          Get.off(const HistoryPage());
        },
      );
    } else {
      // Gagal melakukan transfer
      showSnackBar(context, 'Failed to transfer');
    }
  }
}
