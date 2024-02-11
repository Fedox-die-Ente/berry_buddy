import 'package:berry_buddy/ui/widgets/myProfileForm.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({required this.userId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return MyProfileForm(userId: widget.userId);
  }
}
