import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';
import '../../repositories/userRepository.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginBloc? _loginBloc;

  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onEmailChanged() {
    _loginBloc?.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc?.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc?.add(
      LoginWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(

        listener: (context, state) {
          if (state.isFailure) {
            Scaffold.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Login Failed"),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
          }

          if (state.isSubmitting) {
            Scaffold.of(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(" Logging In..."),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }

          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          }
        },

        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            // Use the state to build your UI
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.deepPurple.shade900,
                    Colors.deepPurple.shade800,
                    Colors.deepPurple.shade400
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 80,),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Login", style: GoogleFonts.redHatDisplay(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Welcome back on BerryBuddy.", style: GoogleFonts
                            .redHatDisplay(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(topLeft: Radius
                              .circular(60), topRight: Radius.circular(60))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 60,),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [BoxShadow(
                                      color: Color.fromRGBO(60, 21, 117, .3),
                                      blurRadius: 20,
                                      offset: Offset(0, 10)
                                  )
                                  ]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            color: Colors.deepPurpleAccent
                                                .shade200))
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      validator: (_) {
                                        return !state.isEmailValid ? "Invalid email" : null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Email or phone number",
                                          hintStyle: TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      validator: (_) {
                                        return !state.isPasswordValid
                                            ? "Invalid password"
                                            : null;
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                              color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40,),
                            // FadeInUp(duration: const Duration(milliseconds: 1500), child: Text("Forgot Password?", style: GoogleFonts.redHatDisplay(color: Colors.grey),)),
                            InkWell(
                              onTap: () {
                                print('Text wurde geklickt!');
                              },
                              child: Text(
                                "Forgot Password? Click here.",
                                style: GoogleFonts.redHatDisplay(
                                    color: Colors.grey),
                              ),
                            ),

                            const SizedBox(height: 40,),
                            MaterialButton(
                              onPressed: () {
                                isLoginButtonEnabled(state)
                                    ? _onFormSubmitted()
                                    : null;
                              },
                              height: 50,
                              color: isLoginButtonEnabled(state) ? Colors.purple[900] : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Login", style: GoogleFonts.redHatDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 40,),

                            InkWell(
                              onTap: () {

                              },
                              child: Text(
                                  "Don't have an account? Create one here.",
                                  style: GoogleFonts.redHatDisplay(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}