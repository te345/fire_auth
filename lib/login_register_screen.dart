import 'package:fire_auth/home_screen.dart';
import 'package:fire_auth/string_extension_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'app_utils.dart';

class LoginRegisterScreen extends StatefulWidget {
  final bool isLogin;

  const LoginRegisterScreen({super.key, required this.isLogin});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  var emailTextController = TextEditingController();
  var passwordTextController = TextEditingController();

  bool isLoading = false;

  void validateUserInput() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (emailTextController.text.trim().isValidEmail) {
      if (passwordTextController.text.trim().isValidPassword) {
        showLoaderDialog(context);

        if (widget.isLogin) {
          onLoginTap();
        } else {
          onRegisterTap();
        }
      } else {
        showInSnackBar('Password should be in between 8 and 12', context);
      }
    } else {
      showInSnackBar('Enter a valid email address', context);
    }
  }

  void onLoginTap() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );
      if (userCredential.user != null) {
        navigateToHome(userCredential.user!.email!);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showInSnackBar(e.message.toString(), context);
    }
  }

  void onRegisterTap() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text.trim(),
        password: passwordTextController.text.trim(),
      );

      if (userCredential.user != null) {
        navigateToHome(userCredential.user!.email!);
      }
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showInSnackBar(e.message.toString(), context);
    }
  }

  void navigateToHome(String email) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen(userEmail: email)),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.only(top: size.height * 0.17, left: 24, right: 24),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 16),
            child: Column(
              children: <Widget>[
                Text(
                  widget.isLogin ? 'Login' : 'Register',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: MediaQuery.of(context).size.width * 0.1),
                CustomTextFieldWgt(
                  label: 'E-Mail ID',
                  hintTxt: 'Enter your email address',
                  maxLen: 30,
                  textEditingController: emailTextController,
                ),
                const SizedBox(height: 24),
                CustomTextFieldWgt(
                  label: 'Password',
                  hintTxt: 'Enter your password',
                  maxLen: 12,
                  isObscure: true,
                  textEditingController: passwordTextController,
                ),
                GestureDetector(
                  onTap: () {
                    validateUserInput();
                  },
                  child: Container(
                    height: 48,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(bottom: 24, top: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                widget.isLogin
                    ? Text.rich(
                        TextSpan(
                          text: 'Don\'t have an account? ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Register',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginRegisterScreen(
                                              isLogin: false)));
                                },
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    : Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Login',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginRegisterScreen(
                                                  isLogin: true)),
                                      (Route<dynamic> route) => false);
                                },
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWgt extends StatelessWidget {
  final String label;
  final String hintTxt;
  final bool isObscure;
  final int maxLen;
  final TextEditingController textEditingController;

  const CustomTextFieldWgt({
    super.key,
    required this.label,
    required this.hintTxt,
    required this.maxLen,
    this.isObscure = false,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: isObscure,
      maxLength: maxLen,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintTxt,
        contentPadding: const EdgeInsets.only(top: 4, left: 12, right: 12),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
