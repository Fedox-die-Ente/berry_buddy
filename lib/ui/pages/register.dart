import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/signup/signup_bloc.dart';
import '../../repositories/userRepository.dart';
import '../widgets/register/RegisterForm.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          userRepository: _userRepository,
        ),
        child: SignUpForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}
