// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/message/snackbar.dart';
import 'package:go_saku/domain/screens/login_screen.dart';
import 'package:go_saku/core/network/api_user.dart';

import '../../app/circular_indicator/customCircular.dart';

import '../../app/controller/textediting_controller.dart';
import '../../app/dialog/showDialog.dart';
import '../../app/widgets/register_widget.dart';
import '../model/abstract/usecase/userUsecase.dart';
import '../model/user.dart';
import '../repository/user_repository.dart';
import '../use_case/user_usecase.dart';

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
              image: AssetImage('lib/assets/login.png'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              children: [
                LayoutBuilder(builder: (context, constraints) {
                  double screenHeight = MediaQuery.of(context).size.height;
                  double containerHeight = screenHeight * 0.43;
                  double screenWidth = MediaQuery.of(context).size.width;
                  double containerWidth = screenWidth * 0.9;
                  double containerMargin = screenHeight * 0.38;

                  return Container(
                    height: containerHeight,
                    width: containerWidth,
                    margin: EdgeInsets.only(top: containerMargin),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
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
                          buildTextField('Address', Icons.location_city,
                              addressController),
                        ],
                      ),
                    ),
                  );
                }),
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
                                String name = nameController.text;
                                String username = usernameController.text;
                                String email = emailController.text;
                                String password = passwordController.text;
                                String phoneNumber = phoneController.text;
                                String address = addressController.text;

                                // Memeriksa apakah semua field telah terisi
                                if (name.isEmpty ||
                                    username.isEmpty ||
                                    email.isEmpty ||
                                    password.isEmpty ||
                                    phoneNumber.isEmpty ||
                                    address.isEmpty) {
                                  showSnackBar(
                                      context, 'All fields must be filled');
                                  return;
                                }

                                // Memeriksa format email
                                if (!email.endsWith('@gmail.com')) {
                                  showSnackBar(context,
                                      'Invalid email format. Email must end with @gmail.com');
                                  return;
                                }

                                // Memeriksa format password
                                if (!RegExp(
                                        r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$')
                                    .hasMatch(password)) {
                                  showSnackBar(context,
                                      'Invalid password format. Password must have at least 1 uppercase letter, 1 number, and minimum 8 characters');
                                  return;
                                }

                                // Memeriksa format nomor telepon
                                if (!RegExp(r'^\d{11,13}$')
                                    .hasMatch(phoneNumber)) {
                                  showSnackBar(context,
                                      'Invalid phone number format. Phone number must consist of 11 to 13 digits');
                                  return;
                                }

                                User user = User(
                                  name: name,
                                  username: username,
                                  email: email,
                                  password: password,
                                  phoneNumber: phoneNumber,
                                  address: address,
                                  balance: 0,
                                  point: 0,
                                  role: 'user',
                                );

                                final result = await userUseCase.register(user);
                                if (result != null) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return const CustomCircularProgressIndicator(
                                        message: 'Loading',
                                      );
                                    },
                                  );
                                  showCustomDialog(
                                    context,
                                    'success',
                                    'Account registered successfully',
                                    () {
                                      Get.off(const login_Screnn());
                                    },
                                  );
                                } else {
                                  showSnackBar(context, 'Failed to register');
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
          ),
        ),
      ),
    );
  }
}
