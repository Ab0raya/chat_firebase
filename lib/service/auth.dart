import 'package:chat_firebase/helper/helper.dart';
import 'package:chat_firebase/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Future registUserWithEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        await Database(userId: user.uid).savingUserData(name, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    }
  }

  Future loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return'Wrong password provided for that user.';
      }
    }
  }

  Future signOut() async {
    try {
      Helper.saveUserLoggedInStatus(false);
      Helper.saveUserNameSF('');
      Helper.saveUserEmailSF('');
      firebaseAuth.signOut();

    } catch (e) {
      return null;
    }
  }
}
