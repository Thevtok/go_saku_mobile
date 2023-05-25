// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/widgets/password_widget.dart';
import 'package:go_saku/app/widgets/register_widget.dart';
import 'package:go_saku/domain/screens/register_screen.dart';

import '../../app/controller/login_controller.dart';

// ignore: camel_case_types
class login_Screnn extends StatefulWidget {
  const login_Screnn({super.key});

  @override
  State<login_Screnn> createState() => _login_ScrennState();
}

// ignore: camel_case_types
class _login_ScrennState extends State<login_Screnn> {
  LoginController lg = LoginController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHeight = screenHeight * 0.2;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/login.png'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: paddingHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    buildTextField(
                        'Email', Icons.email_rounded, lg.emailController),
                    PasswordTextField(controller: lg.passwordController)
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
                            onTap: () {
                              lg.login(context);
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
                              Get.to(const RegisterScreen());
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
        ),
      ),
    );
  }
}
