import 'package:chat_firebase/pages/chat_page.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';
class ChatItem extends StatelessWidget {
   const ChatItem({super.key, required this.userName, required this.chatName, required this.chatId});
  final String userName ;
  final String chatName ;
  final String chatId ;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(chatName: chatName, chatId: chatId, userName: userName)));
        //  Navigator.pushReplacementNamed(context, ChatScreen.id);
      },
      child: Padding(
        padding:  const EdgeInsets.all(10.0),
        child: Container(
          width: 200,
          height: 120,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
               Padding(
                padding:  const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: a1,
                  radius: 40,
                  child: Text(chatName.substring(0,1).toUpperCase(),style:  TextStyle(fontSize: 50,fontWeight: FontWeight.bold,color: a6),),
                ),
              ),
              Padding(
                padding:   const EdgeInsets.only(
                     left: 12),
                child: Text(
                  chatName,
                  style:  TextStyle(
                      fontSize: 20,
                      color: isDark! ? a6 : a7,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
