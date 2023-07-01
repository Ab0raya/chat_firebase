import 'package:chat_firebase/pages/home_page.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:chat_firebase/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';
import '../service/auth.dart';

class InfoPage extends StatefulWidget {
  const InfoPage(
      {super.key,
      required this.chatName,
      required this.chatId,
      required this.adminName});

  final String chatName;
  final String chatId;
  final String adminName;

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Stream? members;
  Auth auth = Auth();

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    Database(userId: FirebaseAuth.instance.currentUser!.uid)
        .getMembers(widget.chatId)
        .then((value) {
          setState(() {
            members = value;
          });

    });
  }

  String getName(String src){
    return src.substring(src.indexOf("_")+1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark! ? a7 : a6,
      body: Padding(
        padding: const EdgeInsets.only(top: 38.0),
        child: Column(
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
                  'Group info',
                  style: TextStyle(
                      color: a1, fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Leave the group'),
                            content:
                            const Text('Are you sure that you want to left the group'),
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
                                    Database(
                                        userId: FirebaseAuth
                                            .instance.currentUser!.uid)
                                        .toggleGroupJoin(
                                        widget.chatId,
                                        getName(widget.adminName),
                                        widget.chatName)
                                        .whenComplete(() {
                                      nextPageNamedReplacement(context, HomePage.id);
                                    });
                                  },
                                  child: const Text('Yes')),
                            ],
                          );
                        });
                  },
                  icon:  Icon(
                    Icons.exit_to_app,
                    color: a1,
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: a1.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: a1,
                      child: Text(
                        widget.chatName.substring(0, 1).toUpperCase(),
                        style:  TextStyle(
                          color: a6,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Group : ${widget.chatName}',style: const TextStyle(fontSize: 18),),
                        Text('Admin : ${getName(widget.adminName)}',style: const TextStyle(fontSize: 18),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }
  memberList(){
    return  StreamBuilder(
        stream: members,
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data['members'] != null){
              if(snapshot.data['members'].length != 0){
                return ListView.builder(
                  itemCount:snapshot.data['members'].length ,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric( horizontal: 18.0),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: a1.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: a1,
                            child: Text(
                              getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),
                              style:  TextStyle(
                                color: a6,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(getName(snapshot.data['members'][index]),style: const TextStyle(fontSize: 18),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }else{
                return const Center(child: Text("There's no members"),);
              }
            }else{
              return const Center(child: Text("There's no members"),);
            }

          }else{
              return  const Center(
                  child: CircularProgressIndicator());
            }


    });
  }
}
