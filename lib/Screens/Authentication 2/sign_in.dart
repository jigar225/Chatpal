import 'package:chatbot/Model/customfield.dart';
import 'package:chatbot/Screens/Authentication%202/forgot_password.dart';
import 'package:chatbot/Screens/Authentication%202/sign_up.dart';
import 'package:chatbot/helper/pref.dart';
import 'package:chatbot/helper/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;

  signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "error message",
        e.code,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: const EdgeInsets.all(5),
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.error, color: Colors.white),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } catch (e) {
      Get.snackbar("error message", e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Pref.showonbording = false;
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ScaffoldGradientBackground(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF7E7F5),
                Color(0xFFF7E7F5),
                Color(0xFFFFF4E0),
                Color(0xFFFFF4E0),
              ],
            ),
            body: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: GoogleFonts.inter(
                          fontSize: size.width * 0.09,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            CustomField(
                              size: size,
                              htext: "Email",
                              preicon: Icons.email_rounded,
                              title: "Email",
                              controller: email,
                              valid: validatemail,
                            ),
                            CustomField(
                              size: size,
                              htext: "Password",
                              preicon: Icons.lock_outline_rounded,
                              title: "Password",
                              controller: password,
                              valid: validatepassword,
                              sufIcon: Icons.remove_red_eye,
                              sufIcon2: Icons.visibility_off,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassword(),
                                  ),
                                );
                              },
                              child: Text("Forgot Password?",
                                  style: GoogleFonts.inter(
                                      fontSize: size.width * 0.04,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple)),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.02,
                        ),
                        child: SizedBox(
                          height: size.height * 0.065,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: (){
                              if(formkey.currentState!.validate()){
                                signIn();
                              }
                            },
                            child: Text("LOGIN",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: size.width * 0.065,
                                )),
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an Account? ",
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: "SIGN UP",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                              style: GoogleFonts.inter(
                                  fontSize: size.width * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
