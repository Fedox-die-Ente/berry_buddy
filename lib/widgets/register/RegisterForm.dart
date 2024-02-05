import 'package:berry_buddy/blocs/authentication/authentication_bloc.dart';
import 'package:berry_buddy/blocs/authentication/authentication_event.dart';
import 'package:berry_buddy/blocs/signup/bloc.dart';
import 'package:berry_buddy/repositories/userRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  final UserRepository _userRepository;

  SignUpForm({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Register createState() => Register();
}

class Register extends State<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DateTime? selectedDate;
  final TextEditingController birthdateController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isSignUpButtonEnabled(state) {
    return isPopulated && !state.isSubmitting;
  }

  SignUpBloc? _signUpBloc;

  void _onEmailChanged() {
    _signUpBloc?.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _signUpBloc?.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _signUpBloc = BlocProvider.of<SignUpBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  void _onFormSubmitted() {
    print("asgakjasaikga");
    _signUpBloc?.add(
      SignUpWithCredentialsPressed(
          email: _emailController.text, password: _passwordController.text),
    );
  }

  // Register({required UserRepository userRepository})
  //     : _userRepository = userRepository;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (BuildContext context, SignUpState state) {
          if (state.isFailure) {
            Scaffold.of(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Sign Up failed"),
                      Icon(Icons.error),
                    ],
                  ),
                ),
              );
          }
          if (state.isSubmitting) {
            print("isSubmitting");
            Scaffold.of(context);

                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Signing up..."),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            print("Success");
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            Navigator.of(context).pop();
          }
        },


        child: BlocBuilder<SignUpBloc, SignUpState>(


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
                        Text("Register", style: GoogleFonts.redHatDisplay(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text("Thanks for choosing BerryBuddy.", style: GoogleFonts.redHatDisplay(color: Colors.white, fontSize: 18)),
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
                                    child: TextFormField(
                                      controller: _emailController,
                                      validator: (_) {
                                        return !state.isEmailValid ? "Invalid email" : null;
                                      },
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
                                    child: TextFormField(
                                      controller: _passwordController,
                                      autocorrect: false,
                                      obscureText: true,
                                      validator: (_) {
                                        return !state.isPasswordValid
                                            ? "Invalid password." : null;
                                      },
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
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.deepPurpleAccent)),
                              ),
                              child: TextField(
                                controller: birthdateController,
                                onTap: () async {
                                  DateTime currentDate = DateTime.now();
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: currentDate,
                                    firstDate: DateTime(1900),
                                    lastDate: currentDate,
                                  );

                                  if (pickedDate != null && pickedDate != currentDate) {
                                    birthdateController.text = pickedDate.toLocal().toString().split(' ')[0];
                                    selectedDate = pickedDate;
                                  }
                                },
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Birthdate",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40,),
                            MaterialButton(
                                onPressed: () {
                                  isSignUpButtonEnabled(state)
                                      ? _onFormSubmitted()
                                      : null;
                                },
                              // onPressed: () {
                              //   String email = _emailController.text.trim();
                              //   String password = _passwordController.text.trim();
                              //
                              //   if (!Validators.isValidEmail(email)) {
                              //     showDialog(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         return AlertDialog(
                              //           title: const Text('Error'),
                              //           content: const Text('Please enter a valid email.'),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //               child: const Text('OK'),
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //     return;
                              //   }
                              //
                              //   if (selectedDate != null) {
                              //     DateTime currentDate = DateTime.now();
                              //     int age = currentDate.year - selectedDate!.year;
                              //
                              //     if (currentDate.month < selectedDate!.month ||
                              //         (currentDate.month == selectedDate!.month &&
                              //             currentDate.day < selectedDate!.day)) {
                              //       age--;
                              //     }
                              //
                              //     if (age < 12) {
                              //       showDialog(
                              //         context: context,
                              //         builder: (BuildContext context) {
                              //           return AlertDialog(
                              //             title: const Text('Error'),
                              //             content: const Text('You must be at least 12 years old to register.'),
                              //             actions: <Widget>[
                              //               TextButton(
                              //                 onPressed: () {
                              //                   Navigator.of(context).pop();
                              //                 },
                              //                 child: const Text('OK'),
                              //               ),
                              //             ],
                              //           );
                              //         },
                              //       );
                              //       return;
                              //     }
                              //   }
                              //
                              //   //_userRepository.signUpWithEmail(email, password);
                              // },
                              height: 50,
                              //color: Colors.purple[900],
                              color: isSignUpButtonEnabled(state) ? Colors.purple[900] : Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text("Register", style: GoogleFonts.redHatDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 40,),
                            InkWell(
                              onTap: () {
                                // TODO: Redirect to login
                              },
                              child: Text("Already have one? Log in here.", style: GoogleFonts.redHatDisplay(color: Colors.white, fontWeight: FontWeight.bold)),
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


