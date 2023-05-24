// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/bank.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:intl/intl.dart';

import '../../app/widgets/appbar_profile.dart';
import '../../app/widgets/profile_widget.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/abstract/repository/userRepo.dart';
import '../model/abstract/usecase/userUsecase.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../use_case/user_usecase.dart';

class profile_Screen extends StatefulWidget {
  const profile_Screen({Key? key}) : super(key: key);

  @override
  State<profile_Screen> createState() => _profile_ScreenState();
}

class _profile_ScreenState extends State<profile_Screen> {
  int _selectedIndex = 2;
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

  late Future<User?> _userResponseFuture;
  late ApiClient apiClient;
  late UserRepository userRepository;
  late UserUseCase userUsecase;

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
    return FutureBuilder<User?>(
        future: _userResponseFuture,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while the future is in progress
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle the error state
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null) {
            // Handle the case where no user data is available
            return const Text('No user data available');
          } else {
            final User user = snapshot.data!;
            // Access the 'result' field
            return Scaffold(
              appBar: CustomAppBar(user: user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: const Text(
                        'GENERAL INFORMATION',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    buildRowWithIcon(
                      "Saldo",
                      'Rp ${NumberFormat('#,###').format(user.balance)}',
                      Icons.arrow_forward,
                    ),
                    buildRowWithIconButton(
                        "Bank Account", "", Icons.arrow_forward, () {
                      Get.to(const BankPage());
                    }),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: const Text(
                        'EMAIL AND PASSWORD',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    buildRowWithIcon("Email", user.email, Icons.arrow_forward),
                    buildRowWithIcon("Password", "****", Icons.arrow_forward),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: const Text(
                        'ACCOUNT INFORMATION',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    buildRowWithIcon(
                        "Username", user.username, Icons.arrow_forward),
                    buildRowWithIcon(
                        "Address", user.address, Icons.arrow_forward),
                    buildRowWithIcon("Point          ", user.point.toString(),
                        Icons.arrow_forward),
                    buildRowWithIconButton('Logout', '', Icons.logout, () {
                      logout();
                    })
                  ],
                ),
              ),
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
            );
          }
        });
  }
}
