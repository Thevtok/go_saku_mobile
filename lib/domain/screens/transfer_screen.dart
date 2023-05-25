// ignore_for_file: camel_case_types, unnecessary_null_comparison, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:go_saku/app/widgets/transfer_widget.dart';
import 'package:go_saku/domain/repository/user_repository.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/use_case/user_usecase.dart';

import '../../app/controller/transaction_controller.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/user.dart';

class transfer_Screen extends StatefulWidget {
  const transfer_Screen({super.key});

  @override
  State<transfer_Screen> createState() => _transfer_ScreenState();
}

class _transfer_ScreenState extends State<transfer_Screen> {
  TransactionController tx = TransactionController();

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final userRepo = UserRepositoryImpl(apiClient);
    final userUsecase = UserUseCaseImpl(userRepo);

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
                                        controller: tx.phoneController,
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
                                  controller: tx.amountController,
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
                                          tx.makeTransfer(context, user!);
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
