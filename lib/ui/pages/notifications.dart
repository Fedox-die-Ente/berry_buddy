import 'package:flutter/cupertino.dart';

class Notifications extends StatefulWidget {
  final String userId;

  const Notifications({required this.userId});

  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Notifications",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

}