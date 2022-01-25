import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _fAuth = FirebaseAuth.instance;


  Future<User?> signIn(String email, String password) async{
    UserCredential result = await _fAuth.signInWithEmailAndPassword(
        email: email,
        password: password
    );
    User? user = result.user;
    return user;
  }


  Future<User?> register(String email, String password) async{
    try{
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = result.user;
      return user;
    }catch(e){
      return null;
    }
  }



  Future<dynamic> passwordToHomePage(String password) async{
    UserPassword userPassword = UserPassword(password: password);
    return userPassword.password;
  }


  Future logOut() async{
    await _fAuth.signOut();
  }
}




class UserPassword {
  dynamic password;

  UserPassword({required this.password});
}