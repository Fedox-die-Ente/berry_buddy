import 'package:flutter/cupertino.dart';

class Search extends StatefulWidget {
  final String userId;

  const Search({required this.userId});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return const Text(
      "Search",
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }
  
}