import 'package:chatbot/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LastUpadate extends StatelessWidget {
  const LastUpadate({
    super.key,
    required this.lastUpdateText,
  });

  final String lastUpdateText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(mq.width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(top: mq.height * 0.01),
      child: Text(
        lastUpdateText,
        textAlign: TextAlign.center,
        style: GoogleFonts.publicSans(
          fontSize: mq.width * 0.03,
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

