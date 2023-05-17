import 'package:flutter/material.dart';

Widget buildColumnWithIcon(String label, IconData icon,
    {Color color = Colors.grey}) {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Widget buildGestureDetectorWithIcon(
    void Function()? onTap, IconData icon, String text) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 5),
        Text(text),
      ],
    ),
  );
}

Widget buildImageContainer(String imagePath) {
  return Container(
    height: 130,
    width: 280,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}
