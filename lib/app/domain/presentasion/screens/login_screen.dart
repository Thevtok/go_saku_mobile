import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/app/domain/presentasion/screens/homepage.dart';
import 'package:go_saku/app/domain/presentasion/screens/register_screen.dart';

// ignore: camel_case_types
class login_Screnn extends StatefulWidget {
  const login_Screnn({super.key});

  @override
  State<login_Screnn> createState() => _login_ScrennState();
}

// ignore: camel_case_types
class _login_ScrennState extends State<login_Screnn> {
  bool _isObscured = true;

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/assets/login_saku.png'),
              fit: BoxFit.fitHeight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
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
                  height: 120,
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 300),
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: Column(
                    children: [
                      TextField(
                        obscureText: _isObscured,
                        style: const TextStyle(color: Colors.blueAccent),
                        cursorColor: Colors.blueAccent,
                        decoration: const InputDecoration(
                            icon: Icon(
                              Icons.email_rounded,
                              color: Colors.blueAccent,
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent)),
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                      ),
                      TextField(
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
                              onTap: () {
                                Get.to(const HomePage());
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
