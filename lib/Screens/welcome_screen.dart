// lib/widgets/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:chatbot/Widget/last_padate.dart';
import 'package:chatbot/Widget/wrapper_elemnt.dart';

class WelcomeScreen extends StatelessWidget {
  final String firstName;


  // final String lastUpdateText;

  final Function(String) onPromptSelected;

  const WelcomeScreen({
    Key? key,
    required this.firstName,

    // required this.lastUpdateText,

    required this.onPromptSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(

              'Hello $firstName\n  How Can I help?',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: mq.width * 0.065,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),


          // LastUpadate(lastUpdateText: lastUpdateText),

          WrapperElement(
            onPromptSelected: onPromptSelected,
          ),
        ],
      ),
    );
  }
}