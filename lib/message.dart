class Message{
  String? user;
  String? message;
  DateTime? date;

  Message();


  Map<String, dynamic> toJson() => {'user': user, 'message': message, 'date': date};


  Message.fromSnapshot(snapshot)
    : user = snapshot.data()['user'],
      message = snapshot.data()['message'],
      date = snapshot.data()['date'].toDate();

}