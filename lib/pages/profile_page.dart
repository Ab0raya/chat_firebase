import 'package:chat_firebase/pages/home_page.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../helper/colors.dart';
import '../service/auth.dart';
import '../widgets/widgets.dart';
import 'login_page.dart';
class ProfilePage extends StatefulWidget {
   const ProfilePage({super.key, required this.name, required this.email});
  final String name;
  final String email;
  static String id = 'profilePage';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: isDark! ? a7 : a6,
      key: scaffoldKey,
      drawer:  Drawer(
        backgroundColor: isDark! ? a7 : a6,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 52),
          children: [
            Icon(
              Icons.account_circle,
              color: a1,
              size: 160,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                style:  TextStyle(
                    color: a1, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            ListTile(
              selected: true,
              iconColor: isDark! ? a6 : a4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.account_circle),
              title:  Text(
                'Profile',
                style: TextStyle(
                  color: isDark! ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark! ? a6 : a4,
              onTap: (){
                nextPageNamedReplacement(context, HomePage.id);
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.group),
              title: Text(
                'Chats',
                style: TextStyle(
                  color: isDark! ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark! ? a6 : a4,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content:
                        const Text('Are you sure that you want to logout'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text(
                                'No',
                                style: TextStyle(color: a1),
                              )),
                          TextButton(
                              onPressed: () async {
                                await auth.signOut().whenComplete(() {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, LoginPage.id, (route) => false);
                                });
                              },
                              child: const Text('Yes')),
                        ],
                      );
                    });
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.exit_to_app),
              title:  Text(
                'Logout',
                style: TextStyle(
                  color: isDark! ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark! ? a6 : a4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.dark_mode),
              title:  Row(
                children: [
                  Text(
                    'Dark mode',
                    style: TextStyle(
                      color: isDark! ? a6 : a7,
                    ),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: isDark!,
                    onChanged: (value) {
                      setState(() {
                       // isDark! = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding:  const EdgeInsets.only(top: 28.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon:  Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: a1,
                      ),
                    ),
                     Text(
                      'Profile',
                      style: TextStyle(
                        color: a1,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
                        icon:  Icon(
                          Icons.more_vert,
                          color: a1,
                        ))
                  ],
                ),
              ),
               Icon(
                Icons.account_circle,
                color: a1,
                size: 160,
              ),
               Padding(
                padding:  const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                         Text('Name:',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: a1),),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(widget.name,style:  TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: isDark! ? a6 : a7),),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                         Text('Email:',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: a1),),
                        Padding(
                          padding:  const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(widget.email,style:  TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: isDark! ? a6 : a7),),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
