import 'package:flutter/material.dart';

import '../../domain/model/user.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  const CustomAppBar({super.key, required this.user});

  @override
  Size get preferredSize => const Size.fromHeight(200);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 200,
      flexibleSpace: Stack(
        children: [
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
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    user.name,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
