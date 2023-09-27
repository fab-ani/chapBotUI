import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationService {
  bool isEmailVerified = false;
  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await user.reload();

      isEmailVerified = user.emailVerified;
    }
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();
      print('email is senttttttttttttttttttttttttttttttttttttttttt');
    } catch (e) {
      print(
          'error happessssssssssssssssssssssssssssssssssssssss ${e.toString()}');
    }
  }
}
