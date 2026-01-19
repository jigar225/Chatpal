import 'package:chatbot/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashLoading extends StatelessWidget {
  const SplashLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/Lottifiles/Splash_animation.json',
        width: mq.width * 0.8);
  }
}
