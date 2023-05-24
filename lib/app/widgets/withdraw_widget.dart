// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';

import '../../domain/model/bank.dart';
import '../controller/transaction_controller.dart';

Widget buildBankWithdraw(List<Bank>? banks) {
  TransactionController tx = TransactionController();

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
            await tx.withdraw(context, bank);
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
