import 'package:flutter/cupertino.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({required this.userId});

  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Matches> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Matches",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }

}