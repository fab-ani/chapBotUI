import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:my_tips/Bot/recommend.dart';
import 'package:my_tips/Screen/Home/authenticate/authenticate.dart';
import 'package:my_tips/services/auth.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

AuthServices _auth = AuthServices();

class _VerificationPageState extends State<VerificationPage> {
  bool isEmailVerified = false;
  final user = FirebaseAuth.instance.currentUser;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = user!.emailVerified;
    print('isEmailVerified on initialize $isEmailVerified');
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerification(),
      );
    }
  }

  Future sendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
      print('Email is sent');
      const snackBar = SnackBar(content: Text('Email is sent'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar =
          SnackBar(content: Text('error sending email verification $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      print('on checking $isEmailVerified');
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      print('on build $isEmailVerified');
      return const HomePage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(children: [
            const Icon(
              Icons.email_outlined,
              size: 100,
            ),
            const Text(
              'Verify your email adress',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'We have just sent an email verification link on',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              'your email. Please check your email and click on',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              ' that link to verify your email address',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () async {
                await canResendEmail ? sendVerificationEmail() : null;
              },
              child: const Text(
                'resend E-mail link',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const Authenticate()));
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'back to login',
                  style: TextStyle(fontSize: 16),
                ))
          ]),
        ),
      );
    }
  }
}
