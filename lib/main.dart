import 'package:berry_buddy/blocs/authentication/authentication_bloc.dart';
import 'package:berry_buddy/repositories/userRepository.dart';
import 'package:berry_buddy/ui/pages/home.dart';
import 'package:berry_buddy/ui/pages/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'blocs/authentication/authentication_event.dart';
import 'blocs/blocDelegate.dart';
import 'constants.dart';
import 'utils/notify.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final UserRepository _userRepository = UserRepository();

  //BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(userRepository: _userRepository)
            ..add(AppStarted()),
        ),
      ],
      child: MyApp(userRepository: _userRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  MyApp({required UserRepository userRepository})
      : _userRepository = userRepository;

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
      home: Home(userRepository: _userRepository),
    );
  }
}
