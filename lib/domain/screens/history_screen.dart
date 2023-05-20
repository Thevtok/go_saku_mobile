// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/widgets/transaction_widget.dart';
import 'package:go_saku/domain/model/transaction.dart';
import 'package:go_saku/domain/repository/transaction_repository.dart';
import 'package:go_saku/domain/screens/deposit_screen.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/screens/transfer_screen.dart';
import 'package:go_saku/domain/use_case/transaction_usecase.dart';
import 'package:intl/intl.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../use_case/user_usecase.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late double containerHeight;
  double initialContainerHeight = 0.0;
  int selectedMonth = DateTime.now().month;
  bool isExpanded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    containerHeight = MediaQuery.of(context).size.height / 1.8;
    initialContainerHeight = containerHeight;
  }

  void updateContainerHeight() {
    setState(() {
      containerHeight = MediaQuery.of(context).size.height * 0.9;
    });
  }

  void resetContainerHeight() {
    setState(() {
      containerHeight = initialContainerHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isContainerUpdated = false;

    final apiClient = ApiClient();
    final txRepo = TransactionRepositoryImpl(apiClient);
    final txUsecase = TransactionUsecaseImpl(txRepo);
    final userRepository = UserRepositoryImpl(apiClient);
    final userUsecase = UserUseCaseImpl(userRepository);
    return FutureBuilder<List<Transaction>>(
      future: getTokenUserId().then((int? id) {
        if (id != null) {
          return txUsecase.findTxByUserID(id);
        } else {
          throw Exception('user_id tidak tersedia');
        }
      }),
      builder:
          (BuildContext context, AsyncSnapshot<List<Transaction>> snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('History'),
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
            body: const Center(
              child: Text('Tidak ada transaksi'),
            ),
          );
        }
        final transactions = snapshot.data!;

        List<Transaction> filteredTransactions = transactions
            .where((transaction) =>
                transaction.transactionDate.month == selectedMonth)
            .toList();

        return FutureBuilder<UserResponse?>(
            future: getTokenUsername().then((String? username) {
              if (username != null) {
                return userUsecase.findByUsername(username);
              } else {
                throw Exception('Username tidak tersedia');
              }
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final user = snapshot.data;
                return Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/home.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    body: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, top: 45),
                            child: IconButton(
                              onPressed: () {
                                Get.off(const HomePage());
                              },
                              icon: const Icon(Icons.arrow_back),
                              iconSize: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 25),
                                  child: Text(
                                    "Availabe Balance",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(
                                    'Rp ${NumberFormat('#,###').format(user!.balance)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500)),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Point",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(user.point.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildColumnWithIconCircle(
                                          'Transfer', Icons.send_rounded, () {
                                        Get.to(const transfer_Screen());
                                      }),
                                      buildColumnWithIconCircle(
                                          'Top Up', Icons.credit_card, () {
                                        Get.to(const DepositPage());
                                      }),
                                      buildColumnWithIconCircle(
                                          'Redeem', Icons.card_giftcard, () {}),
                                      buildColumnWithIconCircle(
                                          'Withdraw', Icons.local_atm, () {}),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Draggable(
                            axis: Axis.vertical,
                            feedback: Container(
                              height: containerHeight,
                              color: Colors.white,
                            ),
                            onDragEnd: (DraggableDetails details) {
                              setState(() {
                                containerHeight += details.offset.dy;
                                isContainerUpdated = true;
                              });
                            },
                            child: GestureDetector(
                              onDoubleTap: () {
                                if (!isContainerUpdated) {
                                  resetContainerHeight();
                                  isContainerUpdated = true;
                                }
                              },
                              child: Container(
                                height: containerHeight,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Color.fromARGB(
                                                255, 116, 114, 114),
                                            width: 5.0,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: const Text(
                                        'Transaksi',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          for (int i = 1; i <= 12; i++)
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedMonth = i;
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                color: selectedMonth == i
                                                    ? Colors.blue
                                                    : Colors.white,
                                                child: Text(
                                                  getMonthName(i),
                                                  style: TextStyle(
                                                    color: selectedMonth == i
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: buildTransactionList(
                                          filteredTransactions, selectedMonth),
                                    ),
                                  ],
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
              return const Scaffold();
            });
      },
    );
  }
}
