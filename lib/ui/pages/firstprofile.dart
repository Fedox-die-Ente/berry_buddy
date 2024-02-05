import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../constants.dart';
import '../../repositories/userRepository.dart';
import '../../widgets/profileForm.dart';

class ProfileSetup extends StatelessWidget {
  final _userRepository;
  final userId;

  ProfileSetup({required UserRepository userRepository, String? userId})
      : assert(userId != null),
        _userRepository = userRepository,
        userId = userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileBloc>(
        create: (context) => ProfileBloc(userRepository: _userRepository),
        child: ProfileForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}