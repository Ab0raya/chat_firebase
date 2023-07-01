import 'package:chat_firebase/pages/info_page.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:chat_firebase/widgets/message_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../helper/colors.dart';

class ChatPage extends StatefulWidget {
  final String chatName;

  final String chatId;

  final String userName;

  const ChatPage(
      {super.key,
      required this.chatName,
      required this.chatId,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  FocusNode myFocusNode = FocusNode();
  TextEditingController messageController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  ScrollController scrollController = ScrollController();
  String admin = '';
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    getAdminAndChats();
    super.initState();
  }

  getAdminAndChats() {
    Database().getChats(widget.chatId).then((value) {
      setState(() {
        chats = value;
      });
    });
    Database().getGroupAdmin(widget.chatId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? a7 : a6,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: AppBar(
            leadingWidth: 108,
            centerTitle: true,
            elevation: 0,
            backgroundColor: isDark ? a7 : a6,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_sharp,
                    color: a1,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: a1,
                  radius: 30,
                  child: Text(
                    widget.chatName.substring(0, 1).toUpperCase(),
                    style:  TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30,color:a6 ),
                  ),
                ),
              ],
            ),
            title: Text(
              widget.chatName,
              style: TextStyle(
                  fontSize: 20,
                  color: isDark ? a6 : a7,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InfoPage(
                              chatName: widget.chatName,
                              chatId: widget.chatId,
                              adminName: admin)));
                },
                icon: Icon(
                  Icons.info_outlined,
                  color: a1,
                  size: 40,
                ),
              ),
              IconButton(
                onPressed: () {
                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
                },
                icon: Icon(
                  Icons.arrow_downward_sharp,
                  color: a1,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: isDark
                    ? const AssetImage('assets/images/chatBGdark.jpg')
                    : const AssetImage('assets/images/chatBG.jpg'),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: chatMessages(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (data){
                    },
                    focusNode: myFocusNode,
                    onSubmitted: (data){
                      myFocusNode.requestFocus();
                      sendMessage();
                    },
                    style: TextStyle(color: isDark ? a6 : a2),
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Send message',
                      hintStyle: TextStyle(color: isDark ? a6 : a7),
                      suffixIcon: IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: Icon(
                            Icons.send,
                            color: a1,
                          )),
                      filled: true,
                      fillColor: isDark ? a7 : a6,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Colors.transparent)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageItem(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    isSent:
                        widget.userName == snapshot.data.docs[index]['sender'],
                  );
                });
          } else {
            return Container();
          }
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      Database().sendMessages(widget.chatId, messages);
      setState(() {
        messageController.clear();
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }
}
