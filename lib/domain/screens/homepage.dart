import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/deposit_screen.dart';
import 'package:go_saku/domain/screens/history_screen.dart';
import 'package:go_saku/domain/screens/profile_screen.dart';
import 'package:go_saku/domain/screens/transfer_screen.dart';
import 'package:go_saku/domain/screens/withdraw_screen.dart';
import 'package:go_saku/domain/use_case/user_usecase.dart';

import '../../app/widgets/home_widget.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/abstract/repository/userRepo.dart';
import '../model/abstract/usecase/userUsecase.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePagState();
}

class _HomePagState extends State<HomePage> {
  Future<bool> _onWillPop() async {
    // Show an exit confirmation dialog
    bool exitConfirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Confirmation'),
        content: const Text('Are you sure you want to exit the application?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    if (exitConfirmation) {
      SystemNavigator.pop(); // Exit the application
    }

    return Future.value(false);
  }

  late Future<User?> _userResponseFuture;
  late ApiClient apiClient;
  late UserRepository userRepository;
  late UserUseCase userUsecase;
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      switch (index) {
        case 0:
          Get.off(const HomePage());
          break;
        case 1:
          Get.off(const HomePage());
          break;
        case 2:
          Get.off(const profile_Screen());
          break;
      }
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    userRepository = UserRepositoryImpl(apiClient);
    userUsecase = UserUseCaseImpl(userRepository);
    _userResponseFuture = getTokenUsername().then((String? username) {
      if (username != null) {
        return userUsecase.findByUsername(username);
      } else {
        throw Exception('Username tidak tersedia');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: FutureBuilder<User?>(
          future: _userResponseFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final User user = snapshot.data!;

              return Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/home.jpg'),
                        fit: BoxFit.cover)),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      children: [
                        Positioned(
                          top: constraints.maxHeight * 0.05,
                          right: constraints.maxWidth * 0.04,
                          child: Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: constraints.maxWidth * 0.08,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    top: constraints.maxHeight * 0.05,
                                    left: constraints.maxWidth * 0.04,
                                  ),
                                  child: SizedBox(
                                    height: constraints.maxHeight * 0.08,
                                    width: constraints.maxHeight * 0.08,
                                    child: CircleAvatar(
                                      radius: constraints.maxHeight * 0.05,
                                      backgroundImage: const AssetImage(
                                          'lib/assets/fikri.jpg'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: constraints.maxHeight * 0.02,
                                    left: constraints.maxWidth * 0.04,
                                  ),
                                  child: Text(
                                    'Hello ${user.username}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.12,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Availabe Balance",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: constraints.maxWidth * 0.035,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                    'Rp ${NumberFormat('#,###').format(user.balance)}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: constraints.maxWidth * 0.09,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          top: constraints.maxHeight * 0.12,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: constraints.maxHeight * 0.18),
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: constraints.maxHeight * 0.1,
                                    right: constraints.maxWidth * 0.4,
                                  ),
                                  child: const Text(
                                    "Payment List",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildColumnWithIcon(
                                            'Internet', Icons.language,
                                            color: Colors.red),
                                        buildColumnWithIcon('PDAM', Icons.water,
                                            color: Colors.blueAccent),
                                        buildColumnWithIcon(
                                            'Electric', Icons.electric_bolt,
                                            color: Colors.amber),
                                        buildColumnWithIcon(
                                            'BPJS', Icons.health_and_safety,
                                            color: Colors.green),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildColumnWithIcon(
                                            'Game', Icons.sports_esports,
                                            color: Colors.purpleAccent),
                                        buildColumnWithIcon(
                                            'Voucher', Icons.card_giftcard,
                                            color: Colors.green),
                                        buildColumnWithIcon(
                                            'Gold', Icons.attach_money,
                                            color: Colors.amber),
                                        buildColumnWithIcon(
                                            'More', Icons.more_horiz,
                                            color: Colors.black),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: constraints.maxHeight * 0.04),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: constraints.maxWidth *
                                                    0.14),
                                            child: Text(
                                              'Promo & Discount',
                                              style: TextStyle(
                                                fontSize: constraints.maxWidth *
                                                    0.045,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'See more',
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize:
                                                  constraints.maxWidth * 0.045,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final containerHeight =
                                constraints.maxHeight * 0.12;
                            final containerWidth = constraints.maxWidth * 0.8;

                            return Container(
                              margin: EdgeInsets.only(
                                  bottom: constraints.maxHeight * 0.4),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: containerHeight,
                                  width: containerWidth,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildGestureDetectorWithIcon(() {
                                        Get.to(const DepositPage());
                                      }, Icons.wallet, 'Top Up'),
                                      buildGestureDetectorWithIcon(() {
                                        Get.to(const transfer_Screen());
                                      }, Icons.send, 'Transfer'),
                                      buildGestureDetectorWithIcon(() {
                                        Get.to(const WithdrawPage());
                                      }, Icons.local_atm, 'Withdraw'),
                                      buildGestureDetectorWithIcon(() {
                                        Get.to(const HistoryPage());
                                      }, Icons.history, 'History'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height *
                                0.78, // Ubah nilai 0.675 sesuai kebutuhan Anda
                            left: MediaQuery.of(context).size.width *
                                0.05, // Ubah nilai 0.05 sesuai kebutuhan Anda
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildImageContainer('lib/assets/flip1.jpg'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.05, // Ubah nilai 0.05 sesuai kebutuhan Anda
                                ),
                                buildImageContainer('lib/assets/flip2.png'),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.05, // Ubah nilai 0.05 sesuai kebutuhan Anda
                                ),
                                buildImageContainer('lib/assets/flip3.jpg'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  bottomNavigationBar: BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code_scanner),
                        label: 'Scan QR',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                  ),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
