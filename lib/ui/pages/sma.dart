import 'package:flutter/cupertino.dart';

class SMA extends StatefulWidget {
  final String userId;

  const SMA({required this.userId});

  @override
  _SMAState createState() => _SMAState();
}

class _SMAState extends State<SMA> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "SMA",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

}