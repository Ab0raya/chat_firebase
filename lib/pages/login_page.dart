import 'package:chat_firebase/pages/register_page.dart';
import 'package:chat_firebase/service/auth.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:chat_firebase/widgets/custom_text_field.dart';
import 'package:chat_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helper/colors.dart';
import '../helper/helper.dart';
import '../widgets/custom_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  String email = '';
  String password = '';
  Auth authService = Auth();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Login yasta',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                      SvgPicture.asset(
                        'assets/images/login.svg',
                        width: 400,
                        height: 400,
                      ),
                      CustomTextField(
                        icon: Icons.alternate_email,
                        hint: 'Email',
                        obscured: false,
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        onSubmitted: (value) {},
                      ),
                      CustomTextField(
                        icon: Icons.password,
                        hint: 'Password',
                        obscured: isVisible,
                        hiding: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        visibleIcon: Icons.remove_red_eye,
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                        onSubmitted: (value) {},
                      ),
                      CustomButton(
                        func: () {
                          logIn();
                        },
                        child: 'Login',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            "don't have an account ? ",
                            style: TextStyle(
                              color: a2,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                nextPageNamed(context, RegisterPage.id);
                              },
                              child:  Text(
                                "Register",
                                style: TextStyle(
                                  color: a1,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  logIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      await authService
          .loginWithEmailAndPassword(email, password)
          .then((value) async{
        if (value == true) {
          QuerySnapshot snapshot = await Database(userId: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
          Helper.saveUserLoggedInStatus(true);
          Helper.saveUserEmailSF(email);
          Helper.saveUserNameSF(snapshot.docs[0]['name']);
          nextPageNamedReplacement(context, HomePage.id);
        } else {
          showSnackBar(value, context);
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }
}
