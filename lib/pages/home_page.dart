import 'package:chat_firebase/helper/helper.dart';
import 'package:chat_firebase/pages/login_page.dart';
import 'package:chat_firebase/pages/profile_page.dart';
import 'package:chat_firebase/pages/search_page.dart';
import 'package:chat_firebase/service/auth.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:chat_firebase/widgets/chat_item.dart';
import 'package:chat_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../helper/colors.dart';

class HomePage extends StatefulWidget {
  static String id = 'HomePage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection('groups');
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Auth auth = Auth();
  String name = '';
  String email = '';
  Stream? chats;
  bool isLoading = false;
  String chatName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    await Helper.getEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await Helper.getName().then((value) {
      setState(() {
        name = value!;
      });
    });
    await Database(userId: FirebaseAuth.instance.currentUser!.uid)
        .getUserChats()
        .then((snapshot) {
      chats = snapshot;
    });
  }

  String getId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  String getName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? a7 : a6,
      key: scaffoldKey,
      drawer: Drawer(
        backgroundColor: isDark ? a7 : a6,
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
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: a1, fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            ListTile(
              iconColor: isDark ? a6 : a4,
              selectedColor: a1,
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.group),
              title: Text(
                'Chats',
                style: TextStyle(
                  color: isDark ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark ? a6 : a4,
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return ProfilePage(name: name, email: email);
                }));
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.account_circle),
              title: Text(
                'Profile',
                style: TextStyle(
                  color: isDark ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark ? a6 : a4,
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
                              child: Text(
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
              title: Text(
                'Logout',
                style: TextStyle(
                  color: isDark ? a6 : a7,
                ),
              ),
            ),
            ListTile(
              iconColor: isDark ? a6 : a4,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              leading: const Icon(Icons.dark_mode),
              title: Row(
                children: [
                  Text(
                    'Dark mode',
                    style: TextStyle(
                      color: isDark ? a6 : a7,
                    ),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: isDark,
                    onChanged: (value) async{
                      setState(() {
                        isDark = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Theme Color',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: isDark? a6: a7),),
            ),
            BlockPicker(
              availableColors: const [
                Color(0xff4b86f8),
                Color(0xff80D39B),
                Color(0xff264653),
                Color(0xffe63946),
                Color(0xffe5989b),
                Color(0xff38b000),
                Color(0xffff9f1c),
                Color(0xff8e7dbe),
              ],
                pickerColor: a1,
                onColorChanged: (color){
                  setState(() {
                    a1 = color;
                  });
                }),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 8, right: 8),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Chats',
                    style: TextStyle(
                      color: a1,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: a1,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      nextPage(context, const SearchPage());
                    },
                    icon: Icon(
                      Icons.search,
                      color: a1,
                    ),
                  ),
                ],
              ),
              Expanded(child: chatList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: a1,
        onPressed: () {
          chatDialog(context);
        },
        child: const Icon(Icons.person_add_alt),
      ),
    );
  }

  chatList() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data['groups'].length,
                    itemBuilder: (context, index) {
                      int reverseIndex =
                          snapshot.data['groups'].length - index - 1;
                      return ChatItem(
                        userName: snapshot.data['name'],
                        chatName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        chatId: getId(snapshot.data['groups'][reverseIndex]),
                      );
                    });
              } else {
                return noChats();
              }
            } else {
              return noChats();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  noChats() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              chatDialog(context);
            },
            child: Icon(
              Icons.person_add,
              size: 170,
              color: a1,
            ),
          ),
          Text(
            "No chats available\n you can add chats by click on add icon ",
            style: TextStyle(color: a1, fontSize: 30),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Future chatDialog(context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: isDark ? a7 : a6,
            title: Text(
              'Create new chat',
              style: TextStyle(color: isDark ? a6 : a7),
            ),
            content: SizedBox(
              width: 120,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : TextField(
                      style: TextStyle(color: isDark ? a6 : a2),
                      onChanged: (value) {
                        setState(() {
                          chatName = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Chat name',
                        hintStyle: TextStyle(color: isDark ? a6 : a7),
                        filled: true,
                        fillColor: isDark ? a2.withOpacity(0.3) : a5,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (chatName != '') {
                    setState(() {
                      isLoading = true;
                    });
                    Database(userId: FirebaseAuth.instance.currentUser!.uid)
                        .creatChat(name, FirebaseAuth.instance.currentUser!.uid,
                            chatName)
                        .whenComplete(() {
                      isLoading = false;
                    });
                    Navigator.pop(context);
                  }
                },
                style:
                    ButtonStyle(backgroundColor: MaterialStatePropertyAll(a1)),
                child: const Text('Create'),
              )
            ],
          );
        });
  }
}
