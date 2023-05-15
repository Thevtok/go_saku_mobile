import 'package:flutter/material.dart';

Widget buildRowWithIcon(String label, String value, IconData icon) {
  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  label,
                  style: const TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
