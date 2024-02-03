import 'package:flutter/material.dart';
import '../constants.dart';

class MyTextInput extends StatelessWidget {

  const MyTextInput({
    Key? key,
    required this.placeholder
  }) : super(key: key);

  final String placeholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.deepPurpleAccent.shade200))
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none
        ),
      ),
    );
  }

}