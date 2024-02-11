import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordWidget extends StatelessWidget {
  const ForgotPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('Text wurde geklickt!');
      },
      child: FadeInUp(
        duration: const Duration(milliseconds: 1500),
        child: Text(
          "Forgot Password? Click here.",
          style: GoogleFonts.redHatDisplay(color: Colors.grey),
        ),
      ),
    );
  }
}