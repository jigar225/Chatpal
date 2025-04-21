import 'package:chatbot/Screens/Authentication%202/sign_in.dart';
import 'package:chatbot/Screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            debugPrint("Auth snapshot data: ${snapshot.data}");
            if (snapshot.hasData) {
              return const Homescreen();
            } else {
              return const SignIn();
            }
          }),
    );
  }
}
