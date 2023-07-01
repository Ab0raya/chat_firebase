import 'package:flutter/material.dart';

import '../helper/colors.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final String sender;
  final bool isSent;

  const MessageItem({super.key, required this.message, required this.sender, required this.isSent});

  @override
  Widget build(BuildContext context)  {
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
                blurRadius: 20,
                offset: const Offset(0,1), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: isSent ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Visibility(
                visible: !isSent,
                child: Text(
                  sender,
                  style:  TextStyle(
                    color: isSent ? a2 : a6,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Text(
                message,
                style:  TextStyle(
                  color: isSent ? a2 :a6,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
