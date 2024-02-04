import 'dart:js';

import 'package:berry_buddy/blocs/authentication/authentication_bloc.dart';
import 'package:berry_buddy/repositories/userRepository.dart';
import 'package:berry_buddy/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/authentication/authentication_event.dart';
import 'constants.dart';
import 'utils/notify.dart';


Future<void> main() async {

  NotificationHandler notificationHandler = NotificationHandler();
  await notificationHandler.init();

  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Berry Buddy',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: kBackgroundColor,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (blocContext) {
          AuthenticationBloc authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
          authenticationBloc.add(AppStarted());
          return authenticationBloc;
        },
        child: Home(userRepository: _userRepository),
      ),
    );
  }
}
