import 'package:berry_buddy/repositories/userRepository.dart';
import 'package:berry_buddy/ui/widgets/myProfileForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/profile/profile_bloc.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({required this.userId});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(
          userRepository: UserRepository(),
        ),
        child: MyProfileForm(
          userId: widget.userId,
        ),
      ),
    );
  }
}
