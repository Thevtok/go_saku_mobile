// ignore_for_file: file_names

import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String title, String message,
    VoidCallback onOkPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // Panggil fungsi onOkPressed saat tombol OK ditekan
              onOkPressed();
            },
          ),
        ],
      );
    },
  );
}
