import 'package:firebase_auth/firebase_auth.dart';

import 'package:my_tips/models/user.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //user object based on firebaseuser
  Users? _userFromFirebase(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> signInMethods(email) async {
    List<String> methods = await _auth.fetchSignInMethodsForEmail(email);

    return methods;
  }

  // sign in with email and passwords
  Future signInWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //register with email and password
  Future registerWithEmailAndPass(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOuts() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('errors logong out ${e.toString()}');
      return null;
    }
  }

  String? getCurrentUID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  Future checkAccountCredentials(String email, String password) async {
    User? user = _auth.currentUser;

    try {
      if (user == null) {
        return 'user_not_found';
      }

      AuthCredential credential =
          EmailAuthProvider.credential(email: email, password: password);

      try {
        List<String> signInMethod =
            await _auth.fetchSignInMethodsForEmail(email);

        if (signInMethod.isEmpty) {
          return 'email_not_found';
        }
        await user.reauthenticateWithCredential(credential);
        return 'success';
      } catch (e) {
        return 'reauth_error: $e';
      }
    } catch (e) {
      return 'other_error $e';
    }
  }
}
