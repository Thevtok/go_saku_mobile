// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:go_saku/app/widgets/password_widget.dart';

import '../../app/controller/register_controller.dart';
import '../../app/widgets/register_widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController rg = RegisterController();

  @override
  void dispose() {
    rg.addressController.dispose();
    rg.emailController.dispose();
    rg.nameController.dispose();
    rg.passwordController.dispose();
    rg.phoneController.dispose();
    rg.usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHeight = screenHeight * 0.4;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/login.png'),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: paddingHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      buildTextField('Name', Icons.people, rg.nameController),
                      buildTextField(
                          'Username', Icons.people, rg.usernameController),
                      buildTextField('Email', Icons.email, rg.emailController),
                      PasswordTextField(controller: rg.passwordController),
                      buildTextField(
                          'Phone number', Icons.phone, rg.phoneController),
                      buildTextField(
                          'Address', Icons.location_city, rg.addressController),
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
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                rg.register(context);
                              },
                              splashColor: Colors.blueAccent.shade100,
                              child: const Center(
                                child: Text(
                                  'SIGN UP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
