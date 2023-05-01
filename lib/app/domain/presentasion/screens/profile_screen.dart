import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/domain/presentasion/screens/homepage.dart';

class profile_Screen extends StatefulWidget {
  const profile_Screen({super.key});

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

  @override
  Widget build(BuildContext context) {
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
                      backgroundImage: AssetImage('lib/assets/fikri.jpg'),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Fikri Alfarizi',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    '085311262801',
                    style: TextStyle(
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
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
            buildRowWithIcon("Saldo", "Rp 80000", Icons.arrow_forward),
            buildRowWithIcon("Bank Account", "1", Icons.arrow_forward),
            buildRowWithIcon("Card Account", "1", Icons.arrow_forward),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: const Text(
                'EMAIL AND PASSWORD',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
            buildRowWithIcon(
                "Email", "fikrialfarizi71@gmail.com", Icons.arrow_forward),
            buildRowWithIcon("Password", "****", Icons.arrow_forward),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: const Text(
                'ACCOUNT INFORMATION',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ),
            buildRowWithIcon("Username", "fikri", Icons.arrow_forward),
            buildRowWithIcon(
                "Address", "JL.Al-Amin,Sukabumi", Icons.arrow_forward),
            buildRowWithIcon("Point          ", "10", Icons.arrow_forward),
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
}

Widget buildRowWithIcon(String label, String value, IconData icon) {
  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
