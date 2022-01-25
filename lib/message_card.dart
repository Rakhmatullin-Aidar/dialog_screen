import 'package:dialog_screen/message.dart';
import 'package:dialog_screen/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class MessageCard extends StatelessWidget {
  final Message? message;
  User? user = FirebaseAuth.instance.currentUser;
  MessageCard({this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: user!.email == message!.user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 4)
                ),
              ],
              color: user!.email == message!.user ? yourMessageColor : companionMessageColor,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                Text('${message!.message}', style: messageStyle),
                Text('${message!.user}',
                  style: TextStyle(
                    fontSize: 12,
                    color: user!.email == message!.user ? yourEmailInMessage :  companionEmailInMessage
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
