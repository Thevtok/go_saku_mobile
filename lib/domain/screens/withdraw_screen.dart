// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables, unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/widgets/withdraw_widget.dart';
import 'package:go_saku/domain/screens/bank.dart';

import '../../app/circular_indicator/customCircular.dart';

import '../../app/controller/transaction_controller.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/bank.dart';
import '../repository/bank_repository.dart';
import '../use_case/bank_usecase.dart';

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({Key? key}) : super(key: key);

  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TransactionController tx = TransactionController();
  final apiClient = ApiClient();
  late final bankRepo;
  late final bankUsecase;

  late Future<List<Bank>?> _bankListFuture;
  late int _selectedBankId;

  @override
  void initState() {
    bankRepo = BankRepositoryImpl(apiClient);
    bankUsecase = BankUseCaseImpl(bankRepo);
    super.initState();
    _bankListFuture = getTokenUserId().then((String? id) {
      if (id != null) {
        return bankUsecase.findByUserID(id);
      } else {
        throw Exception('user_id tidak tersedia');
      }
    });
    _selectedBankId = -1;
  }

  @override
  void dispose() {
    tx.amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'lib/assets/abstrak.jpg'), // Ganti dengan path file gambar Anda
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: FutureBuilder<List<Bank>?>(
              future: _bankListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomCircularProgressIndicator(
                    message: 'Loading',
                  );
                } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Silahkan tambah akun bank terlebih dahulu'),
                      IconButton(
                        onPressed: () {
                          Get.off(const BankPage());
                        },
                        icon: const Icon(Icons.arrow_circle_right),
                        color: Colors.blueAccent,
                        iconSize: 40,
                      )
                    ],
                  );
                } else if (snapshot.hasData) {
                  List<Bank>? banks = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20.0),
                      DropdownButtonFormField<Bank>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                            labelText: 'Bank',
                            labelStyle: TextStyle(
                                color: Colors.blueAccent, fontSize: 20),
                            border: OutlineInputBorder(),
                            fillColor: Colors.blueAccent),
                        value: null,
                        onChanged: (Bank? bank) {
                          setState(() {
                            _selectedBankId = bank!.accountId!;
                          });
                        },
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text(
                              'Pilih Bank',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          for (var bank in banks!)
                            DropdownMenuItem(
                              value: bank,
                              child: buildBankWithdraw([bank]),
                            ),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
