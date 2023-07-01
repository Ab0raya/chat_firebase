import 'package:flutter/material.dart';
import '../helper/colors.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {super.key, required this.isSent});

  final bool isSent;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isSent ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: isSent ? a6 : a1,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(13),
              topRight: const Radius.circular(13),
              bottomRight: isSent ? const Radius.circular(13) : const Radius.circular(0),
              bottomLeft: isSent ? const Radius.circular(0) : const Radius.circular(13),
            ),
            boxShadow:  [
              BoxShadow(
                color:Colors.grey.withOpacity(1) ,
                spreadRadius: 2,
                blurRadius: 15,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            'messages.message',
            style:  TextStyle(
              color: isSent ? a2 : a6,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
