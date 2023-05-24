// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/controller/textediting_controller.dart';
import 'package:go_saku/app/widgets/bank_widget.dart';
import 'package:go_saku/core/utils/hive_service.dart';
import 'package:go_saku/domain/model/bank.dart';
import 'package:go_saku/domain/repository/bank_repository.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/use_case/bank_usecase.dart';

import '../../app/circular_indicator/customCircular.dart';
import '../../app/dialog/showDialog.dart';
import '../../app/message/snackbar.dart';
import '../../app/widgets/register_widget.dart';
import '../../core/network/api_user.dart';

class BankPage extends StatelessWidget {
  const BankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final bankRepo = BankRepositoryImpl(apiClient);
    final bankUsecase = BankUseCaseImpl(bankRepo);

    return FutureBuilder<List<Bank>?>(
        future: getTokenUserId().then((String? id) {
          if (id != null) {
            return bankUsecase.findByUserID(id);
          } else {
            throw Exception('user_id tidak tersedia');
          }
        }),
        builder: (BuildContext context, AsyncSnapshot<List<Bank>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan indikator loading jika data masih diambil
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Tangani jika terjadi error saat mengambil data
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Tampilkan teks jika daftar bank null atau kosong
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Bank Account'),
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
                body: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 10, right: 10),
                    child: SizedBox(
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.amber,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(230, 255, 255, 255),
                                  title: const Text(
                                    'Input Data',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildTextField(
                                        'Bank Name',
                                        Icons.credit_card,
                                        bankNameController,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                        width: 20,
                                      ),
                                      buildTextField(
                                        'Account Number',
                                        Icons.credit_score,
                                        bankAccountNumberController,
                                      ),
                                      const SizedBox(height: 16),
                                      buildTextField(
                                        'Name',
                                        Icons.people,
                                        nameController,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String bankName =
                                            bankNameController.text;
                                        String accountNumber =
                                            bankAccountNumberController.text;
                                        String name = nameController.text;

                                        Bank bank = Bank(
                                            bankName: bankName,
                                            accountNumber: accountNumber,
                                            name: name);
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
                                        final result =
                                            await bankUsecase.add(id!, bank);

                                        if (result != null) {
                                          // Login berhasil
                                          showCustomDialog(
                                            context,
                                            'Success',
                                            'Berhasil menambahkan bank account',
                                            () {
                                              Get.off(const HomePage());
                                            },
                                          );
                                        } else {
                                          // Login gagal
                                          showSnackBar(context,
                                              'Invalid email or password');
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.blueAccent.shade700
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          } else {
            final banks = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bank Account'),
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
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: buildBankList(banks)),
                    SizedBox(
                      height: 40,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.amber,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      const Color.fromARGB(230, 255, 255, 255),
                                  title: const Text(
                                    'Input Data',
                                    style: TextStyle(color: Colors.blueAccent),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildTextField(
                                        'Bank Name',
                                        Icons.credit_card,
                                        bankNameController,
                                      ),
                                      const SizedBox(
                                        height: 16,
                                        width: 20,
                                      ),
                                      buildTextField(
                                        'Account Number',
                                        Icons.credit_score,
                                        bankAccountNumberController,
                                      ),
                                      const SizedBox(height: 16),
                                      buildTextField(
                                        'Name',
                                        Icons.people,
                                        nameController,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        String bankName =
                                            bankNameController.text;
                                        String accountNumber =
                                            bankAccountNumberController.text;
                                        String name = nameController.text;

                                        Bank bank = Bank(
                                            bankName: bankName,
                                            accountNumber: accountNumber,
                                            name: name);
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
                                        final result =
                                            await bankUsecase.add(id!, bank);

                                        if (result != null) {
                                          // Login berhasil
                                          showCustomDialog(
                                            context,
                                            'Success',
                                            'Berhasil menambahkan bank account',
                                            () {
                                              Get.off(const HomePage());
                                            },
                                          );
                                        } else {
                                          // Login gagal
                                          showSnackBar(context,
                                              'Invalid email or password');
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.blueAccent.shade700
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
