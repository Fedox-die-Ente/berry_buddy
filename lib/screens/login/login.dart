import 'package:berry_buddy/blocs/login/bloc.dart';
import 'package:berry_buddy/repositories/userRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../ui/pages/register.dart';
import '../../widgets/register/RegisterForm.dart';
import '../../widgets/widget.dart';

class Login extends StatelessWidget {
  final UserRepository _userRepository;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  Login({required UserRepository userRepository})
  : _userRepository = userRepository;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (blocContext) => LoginBloc(userRepository: _userRepository),

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
                        Text("Login", style: GoogleFonts.redHatDisplay(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Welcome back on BerryBuddy.", style: GoogleFonts.redHatDisplay(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
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
                                  )]
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(color: Colors.deepPurpleAccent.shade200))
                                    ),
                                    child: TextField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Email or phone number",
                                          hintStyle: TextStyle(color: Colors.grey),
                                          border: InputBorder.none
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      //border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                    ),
                                    child: TextField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          hintText: "Password",
                                          hintStyle: TextStyle(color: Colors.grey),
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
                                  style: GoogleFonts.redHatDisplay(color: Colors.grey),
                                ),
                            ),

                            const SizedBox(height: 40,),
                            MaterialButton(
                              onPressed: () {
                                String email = emailController.text.trim();
                                String password = passwordController.text.trim();

                                _userRepository.signInWithEmail(email, password);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text('Failed to sign in. Please check your credentials.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              height: 50,
                              color: Colors.purple[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Login", style: GoogleFonts.redHatDisplay(color: Colors.white, fontWeight: FontWeight.bold),),
                              ),
                            ),
                            const SizedBox(height: 40,),

                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
                                      opacity: animation,
                                      child: SignUp(userRepository: _userRepository,),
                                    ),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                      var offsetAnimation = animation.drive(tween);

                                      return SlideTransition(position: offsetAnimation, child: child);
                                    },
                                  ),
                                );
                              },
                              child: Text("Don't have an account? Create one here.", style: GoogleFonts.redHatDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
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