// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/controller/textediting_controller.dart';
import 'package:go_saku/domain/model/transaction.dart';
import 'package:go_saku/domain/repository/transaction_repository.dart';
import 'package:go_saku/domain/screens/history_screen.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/use_case/transaction_usecase.dart';

import '../../core/network/api_user.dart';
import '../../domain/model/bank.dart';
import '../../domain/repository/bank_repository.dart';
import '../../domain/use_case/bank_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

Widget buildBankList(List<Bank>? banks) {
  final apiClient = ApiClient();
  final bankRepo = BankRepositoryImpl(apiClient);
  final bankUsecase = BankUseCaseImpl(bankRepo);
  if (banks == null) {
    // Tangani ketika banks null
    return const SizedBox.shrink(); // Kembalikan widget kosong
  }
  return ListView.builder(
    itemCount: banks.length,
    itemBuilder: (context, index) {
      final bank = banks[index];
      Widget bankImage;
      const double imageSize = 50.0; // Ukuran gambar yang diinginkan

      if (bank.bankName.toLowerCase() == 'mandiri') {
        bankImage = Image.asset('lib/assets/mandiri.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bca') {
        bankImage = Image.asset('lib/assets/bca.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bri') {
        bankImage = Image.asset('lib/assets/bri.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bni') {
        bankImage = Image.asset('lib/assets/bni.png',
            width: imageSize, height: imageSize);
      } else {
        bankImage = Image.asset('lib/assets/bi.png',
            width: imageSize, height: imageSize);
      }

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListTile(
          leading: bankImage,
          title: Text(bank.bankName),
          subtitle: Text(bank.accountNumber),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
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
                          Navigator.of(context).pop(
                              true); // Mengirim nilai true jika "Ya" ditekan
                        },
                      ),
                      TextButton(
                        child: const Text('Tidak'),
                        onPressed: () {
                          Navigator.of(context).pop(
                              false); // Mengirim nilai false jika "Tidak" ditekan
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

                // Lanjutkan dengan logika setelah metode unregByAccId
                if (result != null) {
                  // Bank berhasil dihapus
                  showCustomDialog(
                    context,
                    'Sukses',
                    'Bank berhasil dihapus',
                    () {
                      Navigator.of(context).pop(); // Tutup dialog
                      Get.off(const HomePage()); // Navigasi ke BankPage
                    },
                  );
                } else {
                  // Gagal menghapus bank
                  showSnackBar(context, 'Gagal menghapus bank');
                }
              }
            },
          ),
        ),
      );
    },
  );
}

Widget buildBankListNoDelete(List<Bank>? banks) {
  final apiClient = ApiClient();
  final txRepo = TransactionRepositoryImpl(apiClient);
  final txUsecase = TransactionUsecaseImpl(txRepo);

  if (banks == null) {
    // Tangani ketika banks null
    return const SizedBox.shrink(); // Kembalikan widget kosong
  }
  return ListView.builder(
    shrinkWrap: true,
    itemCount: banks.length,
    itemBuilder: (context, index) {
      final bank = banks[index];
      Widget bankImage;
      const double imageSize = 50.0; // Ukuran gambar yang diinginkan

      if (bank.bankName.toLowerCase() == 'mandiri') {
        bankImage = Image.asset('lib/assets/mandiri.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bca') {
        bankImage = Image.asset('lib/assets/bca.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bri') {
        bankImage = Image.asset('lib/assets/bri.png',
            width: imageSize, height: imageSize);
      } else if (bank.bankName.toLowerCase() == 'bni') {
        bankImage = Image.asset('lib/assets/bni.png',
            width: imageSize, height: imageSize);
      } else {
        bankImage = Image.asset('lib/assets/bi.png',
            width: imageSize, height: imageSize);
      }

      return Card(
        shadowColor: Colors.blue,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          onTap: () async {
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
                        Navigator.of(context).pop(
                            false); // Mengirim nilai false jika "Tidak" ditekan
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
              DepositBank depo = DepositBank(
                  accountHolderName: bank.name,
                  amount: amount,
                  bankName: bank.bankName,
                  accountNumber: bank.accountNumber);

              final result = await txUsecase.makeDepositBank(
                  bank.userId!, selectedAccountId!, depo);

              // Lanjutkan dengan logika setelah metode unregByAccId
              if (result != null) {
                // Bank berhasil dihapus
                showCustomDialog(
                  context,
                  'Sukses',
                  'Deposit Bank Sukses',
                  () {
                    Navigator.of(context).pop(); // Tutup dialog
                    Get.off(const HistoryPage()); // Navigasi ke BankPage
                  },
                );
              } else {
                // Gagal menghapus bank
                showSnackBar(context, 'Gagal deposit bank');
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                bankImage,
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bank.bankName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        bank.accountNumber,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
