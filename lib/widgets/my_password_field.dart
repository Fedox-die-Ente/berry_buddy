import 'package:flutter/material.dart';
import '../constants.dart';

class MyPasswordField extends StatelessWidget {

  const MyPasswordField({
   // Key? key,
    required this.placeholder
  });

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          //border: Border(bottom: BorderSide(color: Colors.grey.shade200))
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none
        ),
      ),
    );
  }

}