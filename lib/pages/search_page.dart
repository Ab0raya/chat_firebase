import 'package:chat_firebase/helper/helper.dart';
import 'package:chat_firebase/pages/chat_page.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:chat_firebase/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';

class SearchPage extends StatefulWidget {
  static String id = 'SearchPage';

   const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isUserSearched = false;
  bool isJoined = false;
  String userName = '';
  User? user;
  QuerySnapshot? searchSnapshot;

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  getCurrentUserIdAndName() async {
    await Helper.getName().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String src) {
    return src.substring(src.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark! ? a7 : a6,
      body: Padding(
        padding:  const EdgeInsets.symmetric(vertical: 38.0),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:  const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
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
                      'Search',
                      style: TextStyle(
                          color: a1, fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ],
                ),
                SizedBox(
                  width: 350,
                  child: Padding(
                    padding:  const EdgeInsets.only(top: 28.0),
                    child: TextField(
                      onSubmitted: (val) {
                        initiateSearch();
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search groups',
                        prefixIcon:  const Icon(Icons.search),
                        filled: true,
                        fillColor: a5.withOpacity(0.4),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide:
                                 const BorderSide(color: Colors.transparent)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:  const BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ),
                isLoading
                    ?  const Center(
                        child: CircularProgressIndicator(),
                      )
                    : groupList()
              ],
            ),
          ),
        ),
      ),
    );
  }

  initiateSearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Database().search(searchController.text).then((snapshot) {
        setState(() {
          isLoading = false;
          isUserSearched = true;
          searchSnapshot = snapshot;
        });
      });
    }
  }

  groupList() {
    return isUserSearched
        ? ListView.builder(
            itemCount: searchSnapshot!.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return groupTile(
                  userName,
                  searchSnapshot!.docs[index]['groupId'],
                  searchSnapshot!.docs[index]['groupName'],
                  searchSnapshot!.docs[index]['admin']
              );
            }
            )
        : Container();
  }

  joinedOrNot(
      String userName, String chatId, String chatName, String admin) async {
    await Database(userId: user!.uid)
        .isUserJoined(chatName, chatId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String chatId, String chatName, String admin) {
    joinedOrNot(userName, chatId, chatName, admin);
    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: a1,
            child: Text(
              chatName.substring(0, 1).toUpperCase(),
              style:  TextStyle(
                color: a6,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
           const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group : $chatName',
                style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: isDark! ? a6 : a7),
              ),
              Text(
                'Admin : ${getName(admin)}',
                style:   TextStyle(
                  fontSize: 16,
                  color: isDark! ? a6 : a7
                ),
              ),
            ],
          ),
           const Spacer(),
           GestureDetector(
                onTap: ()async{
                  await Database(userId: user!.uid).toggleGroupJoin(chatId, userName, chatName);
                  if(isJoined){
                    setState(() {
                      isJoined = !isJoined;
                    });
                    showSnackBar('Successfully joined to group', context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(chatName: chatName, chatId: chatId, userName: userName)));
                  }else{
                    setState(() {
                      isJoined = !isJoined;
                    });
                    showSnackBar('left the group Successfully', context);
                  }
                },
                child: isJoined
                    ?Container(
                    decoration: BoxDecoration(
                      color: a1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child:  Text(
                      'Joined',
                      style: TextStyle(color: a6),
                    ),
                  ):Container(
                  decoration: BoxDecoration(
                    color: a5.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:  const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child:  Text(
                    'Join',
                    style: TextStyle(color: a2),
                  ),
                ),
              )
               ,
        ],
      ),
    );
  }
}
