import 'package:berry_buddy/blocs/notifications/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/notificationForm.dart';

class Notifications extends StatelessWidget {
  final String _userId;

  Notifications({required String userId}) : _userId = userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NotificationBloc>(
        create: (context) => NotificationBloc(
          userId: _userId,
        ),
        child: NotificationWidget(
          userId: _userId,
        ),
      ),
    );
  }
}
