import 'package:berry_buddy/blocs/notifications/bloc.dart';
import 'package:berry_buddy/widgets/notificationForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/userRepository.dart';

class Notifications extends StatelessWidget {
  final UserRepository _userRepository;

  Notifications({required UserRepository userRepository})
      : _userRepository = userRepository;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NotificationBloc>(
        create: (context) => NotificationBloc(
          userRepository: _userRepository ,
        ),
        child: NotificationWidget(
          userRepository: _userRepository,
        ),
      ),
    );
  }

}
