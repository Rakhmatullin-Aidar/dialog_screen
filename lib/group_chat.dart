import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_screen/style.dart';
import 'package:dialog_screen/validation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupChatPage extends StatefulWidget {
  const GroupChatPage({Key? key}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {

  User? user = FirebaseAuth.instance.currentUser;
  late final email = user!.email;
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: title()
      ),
      body: Column(
        children: [
          chat(),
          messageField()
        ],
      ),
    );
  }



  Widget title() => Row(
    children: [
      const CircleAvatar(child: Icon(Icons.chat)),
      const SizedBox(width: 30),
      Column(
        children: [
          const Text('Group chat', style: TextStyle(fontSize: 22)),
          Text('$email', style: const TextStyle(fontSize: 17))
        ],
      )
    ],
  );


  Widget chat() => Expanded(
    child: Container(
      color: bodyColor,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Chat').orderBy('date').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData) return const Text('Начните групповой чат');
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return ListTile(
                title:
                Column(
                  crossAxisAlignment: snapshot.data!.docs[index].get('user') == user!.email ? CrossAxisAlignment.end: CrossAxisAlignment.start,
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
                          color: snapshot.data!.docs[index].get('user') == user!.email ? yourMessageColor : companionMessageColor,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        children: [
                          Text(
                            snapshot.data!.docs[index].get('message'),
                            style: messageStyle
                          ),
                          Text(
                            '${snapshot.data!.docs[index].get('user')}   ${snapshot.data!.docs[index].get('time')}',
                            style: TextStyle(
                              fontSize: 12,
                              color: snapshot.data!.docs[index].get('user') == user!.email ? const Color.fromRGBO(0, 153, 0, 1) :  const Color.fromRGBO(128, 128, 128, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    ),
  );




  Widget messageField() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(5),
    child: Form(
      key: formKey,
      child: SafeArea(
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(5),
                height: 55,
                child: TextFormField(
                  validator: validateMessage,
                  controller: messageController,
                  decoration: const InputDecoration(hintText: ' Message'),
                ),
              ),
            ),
            IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
    ),
  );


  void sendMessage(){
    if(formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('Chat').add({
        'user': user!.email,
        'message': messageController.text,
        'date': DateTime.now(),
        'time': '${DateTime.now().hour.toString().padLeft(2,'0')}:${DateTime.now().minute.toString().padLeft(2,'0')}'
      });
      messageController.clear();
    }
  }

}

