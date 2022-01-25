class MyUser{
  String? email;
  String? password;

  MyUser();

  Map<String, dynamic> toJson() => {'email': email, 'password': password};

}