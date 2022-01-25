import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialog_screen/message.dart';
import 'package:dialog_screen/message_card.dart';
import 'package:dialog_screen/style.dart';
import 'package:dialog_screen/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';





class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  User? user = FirebaseAuth.instance.currentUser;
  final messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final Message? _message = Message();

  List<Object> _chat = [];



  @override
  void didChangeDependencies() {
    getMessage();
    super.didChangeDependencies();
  }


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
          Text('${user!.email}', style: const TextStyle(fontSize: 17))
        ],
      )
    ],
  );



  Widget chat() => Expanded(
    child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
        itemCount: _chat.length,
        itemBuilder: (context, index){
          return SingleChildScrollView(
            child: MessageCard(message: _chat[index] as Message));
        },
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
              onPressed: () async{
                sendMessage();
                getMessage();
              },
              icon: const Icon(Icons.send),
            )
          ],
        ),
      ),
    ),
  );


  Future getMessage() async{
    var data = await FirebaseFirestore.instance.collection('Chat').orderBy('date').get();

    setState(() {
      _chat = List.from(data.docs.map((doc) => Message.fromSnapshot(doc)));
    });
  }




  void sendMessage() async{
    if(formKey.currentState!.validate()){
      _message!.message = messageController.text;
      _message!.user = user!.email;
      _message!.date = DateTime.now();

      await FirebaseFirestore.instance.collection('Chat').add(_message!.toJson());

      messageController.clear();
    }
  }



}
