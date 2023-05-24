// ignore_for_file: unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../domain/model/bank.dart';
import '../controller/bank_controller.dart';

BankController bc = BankController();
Widget buildBankList(List<Bank>? banks) {
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
              await bc.deleteBank(context, bank);
            },
          ),
        ),
      );
    },
  );
}
