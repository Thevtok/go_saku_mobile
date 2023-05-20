import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/hive_service.dart';
import '../../domain/model/transaction.dart';

Future<String?> getTransactionTitle(Transaction transaction) async {
  String? username = await getTokenUsername();

  return username;
}

Widget buildTransactionList(List<Transaction>? transactions, int month) {
  if (transactions == null || transactions.isEmpty) {
    return const Center(
      child: Text('Tidak ada transaksi'),
    );
  }

  List<Transaction> filteredTransactions = transactions
      .where((transaction) => transaction.transactionDate.month == month)
      .toList();

  if (filteredTransactions.isEmpty) {
    return const Center(
      child: Text('Tidak ada transaksi untuk bulan ini'),
    );
  }

  return ListView.builder(
    itemCount: filteredTransactions.length,
    itemBuilder: (context, index) {
      Transaction transaction = filteredTransactions[index];
      if (transaction.transactionType == 'Transfer') {
        return FutureBuilder<String?>(
            future: getTransactionTitle(transaction),
            builder: (context, snapshot) {
              final username = snapshot.data;
              return ListTile(
                leading: transaction.senderName == username
                    ? const Icon(
                        Icons.arrow_circle_right,
                        color: Colors.redAccent,
                      )
                    : const Icon(
                        Icons.arrow_circle_left,
                        color: Colors.green,
                      ),
                title: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 4.0), // Tambahkan jarak pada bagian bawah title
                  child: transaction.senderName == username
                      ? const Text('Transfer Keluar')
                      : const Text('Transfer Masuk'),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(username == transaction.recipientName
                        ? 'Transfer dari ${transaction.senderNumber} ${transaction.senderName.toUpperCase()}'
                        : 'Transfer ke ${transaction.recipientNumber} ${transaction.recipientName.toUpperCase()} '),
                    Text(
                      DateFormat('yyyy-MM-dd')
                          .format(transaction.transactionDate),
                    ),
                  ],
                ),
                trailing: transaction.senderName == username
                    ? Text(
                        '-Rp.${NumberFormat('#,###').format(transaction.amount)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      )
                    : Text(
                        '+Rp.${NumberFormat('#,###').format(transaction.amount)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
              );
            });
      } else if (transaction.transactionType == 'Deposit Bank') {
        return ListTile(
          leading: const Icon(
            Icons.credit_card,
            color: Colors.green,
          ),
          title: const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text('Top up'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top up dari ${transaction.bankName} ${transaction.accountNumber} ${transaction.senderName.toUpperCase()}',
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(transaction.transactionDate),
              ),
            ],
          ),
          trailing: Text(
            '+Rp.${NumberFormat('#,###').format(transaction.amount)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.green,
            ),
          ),
        );
      } else if (transaction.transactionType == 'Withdraw') {
        return ListTile(
          leading: const Icon(
            Icons.local_atm,
            color: Colors.redAccent,
          ),
          title: const Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text('Withdraw'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Penarikan ke ${transaction.bankName} ${transaction.accountNumber} ${transaction.senderName.toUpperCase()}',
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(transaction.transactionDate),
              ),
            ],
          ),
          trailing: Text(
            '-Rp.${NumberFormat('#,###').format(transaction.amount)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.redAccent,
            ),
          ),
        );
      }
      return null;
    },
  );
}

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'Maret';
    case 4:
      return 'April';
    case 5:
      return 'Mei';
    case 6:
      return 'Juni';
    case 7:
      return 'Juli';
    case 8:
      return 'Agustus';
    case 9:
      return 'September';
    case 10:
      return 'Oktober';
    case 11:
      return 'November';
    case 12:
      return 'Desember';
    default:
      return '';
  }
}

Widget buildColumnWithIconCircle(
    String label, IconData icon, void Function()? onPressed) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                size: 35,
                color: const Color.fromARGB(255, 11, 63, 151),
              ),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    ],
  );
}
