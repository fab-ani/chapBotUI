import 'package:flutter/material.dart';

import 'package:my_tips/Screen/Home/authenticate/authenticate.dart';
import 'package:my_tips/Screen/Home/authenticate/verificationPage.dart';

import 'package:my_tips/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_tips/services/auth.dart';

class Wrapper extends ConsumerWidget {
  Wrapper({Key? key}) : super(key: key);

  final usersProvider = StreamProvider<Users?>((ref) {
    return AuthServices().user;
  });

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(usersProvider).when(
        data: (user) {
          if (user != null) {
            return const VerificationPage();
          } else {
            return const Authenticate();
          }
        },
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () {
          return const CircularProgressIndicator();
        });
  }
}
