import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/domain/model/user.dart';
import 'package:go_saku/app/domain/presentasion/screens/login_screen.dart';
import 'package:go_saku/core/network/api_client.dart';

import '../../repository/user_repository.dart';
import '../../use_case/user_usecase.dart';

// ignore: camel_case_types
class register_Screen extends StatefulWidget {
  const register_Screen({super.key});

  @override
  State<register_Screen> createState() => _register_ScreenState();
}

// ignore: camel_case_types
class _register_ScreenState extends State<register_Screen> {
  bool _isObscured = true;

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    final userRepository = UserRepositoryImpl(apiClient);
    final UserUseCase userUseCase = UserUseCaseImpl(userRepository);
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/login_saku.png'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                heightFactor: 10,
                child: Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: const Text(
                    'Go Saku',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Center(
                heightFactor: 10,
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: const Text(
                    'For Simple Payment',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 380,
                    margin:
                        const EdgeInsets.only(left: 20, right: 20, top: 250),
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Column(
                      children: [
                        buildTextField('Name', Icons.people, nameController),
                        buildTextField(
                            'Username', Icons.people, usernameController),
                        buildTextField('Email', Icons.email, emailController),
                        TextField(
                          controller: passwordController,
                          obscureText: _isObscured,
                          style: const TextStyle(color: Colors.blueAccent),
                          cursorColor: Colors.blueAccent,
                          decoration: InputDecoration(
                            icon: const Icon(
                              Icons.lock,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: Colors.blueAccent),
                            suffixIcon: InkWell(
                              onTap: _toggleObscureText,
                              child: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        buildTextField(
                            'Phone number', Icons.phone, phoneController),
                        buildTextField(
                            'Address', Icons.location_city, addressController),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                  final result =
                                      await userUseCase.register(user);
                                  if (result != null) {
                                    Get.to(const login_Screnn());
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Registration failed.'),
                                      ),
                                    );
                                  }
                                },
                                splashColor: Colors.blueAccent.shade100,
                                child: const Center(
                                  child: Text(
                                    'SIGN UP',
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
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(
    String labelText, IconData icon, TextEditingController tx) {
  return TextField(
    controller: tx,
    style: const TextStyle(color: Colors.blueAccent),
    cursorColor: Colors.blueAccent,
    decoration: InputDecoration(
      icon: Icon(
        icon,
        color: Colors.blueAccent,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.blueAccent),
    ),
  );
}

final nameController = TextEditingController();
final usernameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final phoneController = TextEditingController();
final addressController = TextEditingController();

String name = nameController.text;
String username = usernameController.text;
String email = emailController.text;
String password = passwordController.text;
String phoneNumber = phoneController.text;
String address = addressController.text;

User user = User(
    name: name,
    username: username,
    email: email,
    password: password,
    phoneNumber: phoneNumber,
    address: address,
    balance: 0,
    point: 0,
    role: 'user');
