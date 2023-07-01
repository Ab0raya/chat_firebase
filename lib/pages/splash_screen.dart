import 'package:chat_firebase/helper/helper.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Helper.getUserLoggedInState(),
        builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data as bool) {
              return HomePage();
            }
          }
          return LoginPage();
        },
      ),
    );
  }
}
