// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/circular_indicator/customCircular.dart';
import 'package:go_saku/app/dialog/showDialog.dart';
import 'package:go_saku/app/message/snackbar.dart';
import 'package:go_saku/app/widgets/register_widget.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:go_saku/domain/screens/register_screen.dart';

import '../model/abstract/usecase/userUsecase.dart';

import '../use_case/user_usecase.dart';
import 'package:go_saku/core/network/api_user.dart';

import '../repository/user_repository.dart';

// ignore: camel_case_types
class login_Screnn extends StatefulWidget {
  const login_Screnn({super.key});

  @override
  State<login_Screnn> createState() => _login_ScrennState();
}

// ignore: camel_case_types
class _login_ScrennState extends State<login_Screnn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  void dispose() {
    emailController.dispose(); // Dispose of emailController
    passwordController.dispose(); // Dispose of passwordController
    super.dispose();
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
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.25),
                    child: const Text(
                      'Go Saku',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    child: const Text(
                      'For Simple Payment',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 120,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 300),
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Column(
                    children: [
                      buildTextField(
                          'Email', Icons.email_rounded, emailController),
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
                          labelStyle: const TextStyle(color: Colors.blueAccent),
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
                      )
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
                                String email = emailController.text;
                                String password = passwordController.text;
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return const CustomCircularProgressIndicator(
                                      message: 'Loading',
                                    );
                                  },
                                );

                                final result =
                                    await userUseCase.login(email, password);

                                Navigator.pop(
                                    context); // Menutup dialog setelah login selesai

                                if (result != null) {
                                  // Login berhasil
                                  showCustomDialog(
                                    context,
                                    'Success',
                                    'Redirecting to home page',
                                    () {
                                      Get.off(const HomePage());
                                    },
                                  );
                                } else {
                                  // Login gagal
                                  showSnackBar(
                                      context, 'Invalid email or password');
                                }
                              },
                              splashColor: Colors.blueAccent.shade100,
                              child: const Center(
                                child: Text(
                                  'LOGIN',
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("don't have an account?"),
                          TextButton(
                              onPressed: () {
                                Get.to(const register_Screen());
                              },
                              child: const Text(
                                'signup',
                                style: TextStyle(color: Colors.blueAccent),
                              ))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
