import 'package:flutter/material.dart';

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
