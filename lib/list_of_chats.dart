import 'package:dialog_screen/group_chat.dart';
import 'package:dialog_screen/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';


class ChatsList extends StatefulWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  _ChatsListState createState() => _ChatsListState();
}


class _ChatsListState extends State<ChatsList> {

  User? user = FirebaseAuth.instance.currentUser;
  late final email = user!.email;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$email'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          logOutButton()
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            welcome,
            Text('$email', style: emailStyle),
            button()
          ],
        ),
      ),
    );
  }




  Widget button () =>  Container(
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 4)
          ),
        ],
        color: Colors.blue
    ),
    margin: const EdgeInsets.fromLTRB(0, 80, 0, 0),
    child: TextButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const GroupChatPage()));
      },
      child: const Text('Go to group chat', style: TextStyle(color: Colors.white)),
    ),
  );

  Widget logOutButton () =>  TextButton(
      onPressed: logOut,
      child: const Text('Logout', style: TextStyle(color: Colors.white))
  );

  void logOut(){
    AuthService().logOut();
    Navigator.pop(context);
  }
}
