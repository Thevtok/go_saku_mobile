// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordTextField({Key? key, required this.controller})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscured = true;

  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
