import 'package:flutter/cupertino.dart';

class Messages extends StatefulWidget {
  final String userId;

  const Messages({required this.userId});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Messages",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

}