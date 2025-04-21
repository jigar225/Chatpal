import 'package:chatbot/Model/customfield.dart';
import 'package:chatbot/Screens/Authentication%202/sign_in.dart';
import 'package:chatbot/Screens/Authentication%202/wrapper.dart';
import 'package:chatbot/helper/validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  final formkey = GlobalKey<FormState>();

  signUp() async {
    try {
      String? usernameError = await validateUsername(userName.text.trim());
      if (usernameError != null) {
        Get.snackbar(
          "Error",
          usernameError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "userName": userName.text.trim(),
        "email": email.text.trim(),
      });
      Get.offAll(const Wrapper());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "error message",
        e.code,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(5),
        duration: Duration(seconds: 5),
        icon: Icon(Icons.error, color: Colors.white),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } catch (e) {
      Get.snackbar("error message", e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ScaffoldGradientBackground(
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
                  "Sign Up",
                  style: GoogleFonts.inter(
                    fontSize: size.width * 0.09,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.5,
                            child: CustomField(
                              size: size,
                              htext: "First Name",
                              preicon: Icons.person,
                              title: "First Name",
                              controller: firstName,
                              valid: validatefirstname,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.5,
                            child: CustomField(
                              size: size,
                              htext: "Last Name",
                              preicon: Icons.person,
                              title: "Last Name",
                              controller: lastName,
                              valid: validatelastname,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.5,
                        child: CustomField(
                          size: size,
                          htext: "User Name",
                          preicon: Icons.person,
                          title: "User Name",
                          controller: userName,
                          valid: validateUsernameField,
                        ),
                      ),
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
                    vertical: size.height * 0.02,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          signUp();
                        }
                      },
                      child: Text(
                        "SIGN UP",
                        style: GoogleFonts.inter(
                          fontSize: size.width * 0.065,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an Account? ",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      TextSpan(
                        text: "SIGN IN",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignIn(),
                              ),
                            );
                          },
                        style: GoogleFonts.inter(
                          fontSize: size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
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
