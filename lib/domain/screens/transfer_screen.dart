// ignore_for_file: camel_case_types, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/controller/textediting_controller.dart';
import 'package:go_saku/app/widgets/transfer_widget.dart';
import 'package:go_saku/domain/model/transaction.dart';
import 'package:go_saku/domain/repository/transaction_repository.dart';
import 'package:go_saku/domain/repository/user_repository.dart';
import 'package:go_saku/domain/screens/history_screen.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/use_case/transaction_usecase.dart';
import 'package:go_saku/domain/use_case/user_usecase.dart';

import '../../app/circular_indicator/customCircular.dart';
import '../../app/dialog/showDialog.dart';
import '../../app/message/snackbar.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/user.dart';

class transfer_Screen extends StatelessWidget {
  const transfer_Screen({super.key});
  void dispose() {
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool confirmed = false;
    final apiClient = ApiClient();
    final userRepo = UserRepositoryImpl(apiClient);
    final userUsecase = UserUseCaseImpl(userRepo);
    final txRepo = TransactionRepositoryImpl(apiClient);
    final txUsecase = TransactionUsecaseImpl(txRepo);
    final sender = getTokenUsername().then((String? username) {
      if (username != null) {
        return userUsecase.findByUsername(username);
      } else {
        throw Exception('Username tidak tersedia');
      }
    });

    final Size size = MediaQuery.of(context).size;
    final double containerWidth = size.width * 1;
    final double containerHeight = size.height * 1;
    return FutureBuilder<User?>(
        future: sender,
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          final user = snapshot.data;
          return Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/assets/home.jpg'),
                      fit: BoxFit.cover)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'Transfer Balance',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      left: 20,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.arrow_back_outlined),
                        color: Colors.white,
                        onPressed: () {
                          Get.off(const HomePage());
                        },
                      ),
                    ),
                    Positioned(
                      top: 45,
                      right: 20,
                      child: IconButton(
                        iconSize: 35,
                        icon: const Icon(Icons.search_rounded),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    Positioned(
                        top: 140,
                        child: Container(
                          height: containerHeight,
                          width: containerWidth,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40)),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40, left: 20),
                                    child: Text(
                                      'Contact',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: const InputDecoration(
                                          labelText: 'Enter phone number',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, right: 10),
                                  child: Text(
                                    'See all contact',
                                    style: TextStyle(
                                        color: Colors.blueAccent, fontSize: 15),
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, left: 20),
                                  child: Text(
                                    'Recent',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              buildContactCard('Fikri', '083819095181',
                                  'lib/assets/fikri.jpg'),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, left: 20),
                                  child: Text(
                                    'Set amount',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15, left: 20),
                                  child: Text(
                                    'How much would you like to transfer?',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: TextField(
                                  controller: amountController,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildUang('Rp 10.000'),
                                      buildUang('Rp 50.000'),
                                      buildUang('Rp 100.000'),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 180),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  height: 50,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.blueAccent.shade700
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter)),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          final String phoneNumber =
                                              phoneController.text;
                                          int? amount = int.tryParse(
                                              amountController.text);
                                          final recipient = await userUsecase
                                              .findByPhone(phoneNumber);
                                          final id = await getTokenUserId();

                                          if (recipient == null) {
                                            showSnackBar(
                                                context, 'Recipient not found');
                                            return;
                                          }

                                          if (!confirmed) {
                                            final confirmedResult =
                                                await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirm Transfer'),
                                                  content: Text(
                                                      'Are you sure you want to transfer $amount to ${recipient.username}?'),
                                                  actions: [
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Confirm'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                            if (confirmedResult == null ||
                                                !confirmedResult) {
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
                                            senderName: user!.username,
                                            senderPhone: user.phoneNumber,
                                            recipientName: recipient.username,
                                            recipientPhone: phoneNumber,
                                            amount: amount,
                                          );

                                          final result = await txUsecase
                                              .makeTransfer(id!, transfer);

                                          if (result != null) {
                                            showCustomDialog(
                                              context,
                                              'success',
                                              'Transfer successfully',
                                              () {
                                                Navigator.of(context).pop();
                                                Get.off(const HistoryPage());
                                              },
                                            );
                                          } else {
                                            showSnackBar(
                                                context, 'Failed to transfer');
                                          }
                                        },
                                        splashColor: Colors.blueAccent.shade100,
                                        child: const Center(
                                          child: Text(
                                            'Continue',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                  ],
                ),
              ));
        });
  }
}
