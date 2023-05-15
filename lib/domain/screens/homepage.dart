import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePagState();
}

class _HomePagState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/home.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 35, right: 180),
                  child: const SizedBox(
                    height: 60,
                    width: 60,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('lib/assets/fikri.jpg'),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Center(
                child: Column(
                  children: const [
                    Text(
                      "Availabe Balance",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w300),
                    ),
                    Text('Rp 150.000',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Container(
                margin: const EdgeInsets.only(top: 230),
                height: 800,
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 70, right: 200),
                      child: const Text(
                        "Payment List",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildColumnWithIcon('Internet', Icons.language,
                                color: Colors.red),
                            buildColumnWithIcon('PDAM', Icons.water,
                                color: Colors.blueAccent),
                            buildColumnWithIcon('Electric', Icons.electric_bolt,
                                color: Colors.amber),
                            buildColumnWithIcon('BPJS', Icons.health_and_safety,
                                color: Colors.green),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildColumnWithIcon('Game', Icons.sports_esports,
                                color: Colors.purpleAccent),
                            buildColumnWithIcon('Voucher', Icons.card_giftcard,
                                color: Colors.green),
                            buildColumnWithIcon('Gold', Icons.attach_money,
                                color: Colors.amber),
                            buildColumnWithIcon('More', Icons.more_horiz,
                                color: Colors.black),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 70),
                                child: Text(
                                  'Promo & Discount',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                'See more',
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.4),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 80,
                      width: 320,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildGestureDetectorWithIcon(
                              () {}, Icons.wallet, 'Top Up'),
                          buildGestureDetectorWithIcon(
                              () {}, Icons.send, 'Transfer'),
                          buildGestureDetectorWithIcon(
                              () {}, Icons.receipt, 'Request'),
                          buildGestureDetectorWithIcon(
                              () {}, Icons.history, 'History'),
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
      ),
    );
  }
}

Widget buildColumnWithIcon(String label, IconData icon,
    {Color color = Colors.grey}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget buildGestureDetectorWithIcon(
    void Function()? onTap, IconData icon, String text) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    ),
  );
}

Widget buildImageContainer(String imagePath) {
  return Container(
    height: 130,
    width: 280,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}
