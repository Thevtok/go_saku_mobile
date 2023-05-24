// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../controller/bank_controller.dart';
import 'register_widget.dart';

Widget bankNullPage(BuildContext context) {
  BankController bc = BankController();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Bank Account'),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/abstrak.jpg',
            ), // Ganti dengan path file gambar Anda
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
    body: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: SizedBox(
          height: 40,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.amber,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(230, 255, 255, 255),
                      title: const Text(
                        'Input Data',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildTextField(
                            'Bank Name',
                            Icons.credit_card,
                            bc.bankNameController,
                          ),
                          const SizedBox(
                            height: 16,
                            width: 20,
                          ),
                          buildTextField(
                            'Account Number',
                            Icons.credit_score,
                            bc.bankAccountNumberController,
                          ),
                          const SizedBox(height: 16),
                          buildTextField(
                            'Name',
                            Icons.people,
                            bc.nameController,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            bc.addBank(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blueAccent,
                      Colors.blueAccent.shade700,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
