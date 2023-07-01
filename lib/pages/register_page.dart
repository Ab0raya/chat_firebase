import 'package:chat_firebase/helper/helper.dart';
import 'package:chat_firebase/pages/home_page.dart';
import 'package:chat_firebase/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/colors.dart';
import '../service/auth.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  bool isLoading = false;
  String email = '';
  String password = '';
  String name = '';
  Auth authService = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator(color: a1,),): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 80),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Welcome ya ngm',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                SvgPicture.asset(
                  'assets/images/register.svg',
                  width: 350,
                  height: 350,
                ),
                CustomTextField(
                  icon: Icons.tag_faces_rounded,
                  hint: 'Name',
                  obscured: false,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  onSubmitted: (value) {},
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
                  func: () async{
                    // bool isViewed = false;
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.setBool('onBoard', isViewed);
                    register();
                  },
                  child: 'Register',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      "already have an account ? ",
                      style: TextStyle(
                        color: a2,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          nextPageNamed(context, LoginPage.id);
                        },
                        child:  Text(
                          "Login",
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

   register() async{
    if(formKey.currentState!.validate()){
     setState(() {
       isLoading = true ;
     });
     await authService.registUserWithEmailAndPassword(name, email, password).then((value) {
       if(value == true){
          Helper.saveUserLoggedInStatus(true);
          Helper.saveUserEmailSF(email);
          Helper.saveUserNameSF(name);
          nextPageNamedReplacement(context, HomePage.id);
       }else{
         showSnackBar(value, context);
         setState(() {
           isLoading = false ;
         });
       }
     });
    }
   }
}
