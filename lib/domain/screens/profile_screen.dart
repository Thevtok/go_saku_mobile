// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/bank.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:intl/intl.dart';

import '../../app/widgets/profile_widget.dart';
import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';

class profile_Screen extends StatefulWidget {
  const profile_Screen({Key? key}) : super(key: key);

  @override
  State<profile_Screen> createState() => _profile_ScreenState();
}

class _profile_ScreenState extends State<profile_Screen> {
  @override
  void initState() {
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final userRepository = UserRepositoryImpl(apiClient);

    return FutureBuilder<UserResponse?>(
        future: getTokenUsername().then((String? username) {
          if (username != null) {
            return userRepository.getByUsername(username);
          } else {
            throw Exception('Username tidak tersedia');
          }
        }),
        builder: (context, AsyncSnapshot<UserResponse?> snapshot) {
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
            final UserResponse user = snapshot.data!;
            // Access the 'result' field
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 200,
                flexibleSpace: Stack(children: [
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/abstrak.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: const SizedBox(
                            height: 80,
                            width: 80,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  AssetImage('lib/assets/fikri.jpg'),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            user.name,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            user.phoneNumber,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              ),
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
                        "Bank Account", "1", Icons.arrow_forward, () {
                      Get.to(const BankPage());
                    }),
                    buildRowWithIcon("Card Account", "1", Icons.arrow_forward),
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
