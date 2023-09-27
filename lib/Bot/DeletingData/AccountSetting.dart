import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_tips/Bot/DeletingData/deleteDataFromDatabase.dart';
import 'package:my_tips/Screen/Home/wrapper.dart';
import 'package:my_tips/services/Database.dart';
import 'package:my_tips/services/auth.dart';
import 'package:my_tips/services/chatServices.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../shared/constnts.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({Key? key}) : super(key: key);

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

String email = '';

class _AccountSettingsState extends State<AccountSettings> {
  final AuthServices _auth = AuthServices();
  String password = '';
  bool _obscureText = true;
  bool isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ACCOUNT SETTINGS')),
      body: Center(
        child: MaterialButton(
          color: Colors.red,
          elevation: 7,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return isDeleting
                        ? Center(
                            child: Visibility(
                              visible: isDeleting,
                              child: SpinKitFadingCircle(
                                itemBuilder: (context, index) {
                                  return DecoratedBox(
                                      decoration: BoxDecoration(
                                    color: index.isEven
                                        ? const Color(0xffff5722)
                                        : const Color(0xff554994),
                                  ));
                                },
                              ),
                            ),
                          )
                        : AlertDialog(
                            title: const Center(
                              child: Text(
                                'Delete account',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            actions: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration:
                                    textDec.copyWith(hintText: "Email :"),
                                validator: (val) => val!.length < 6
                                    ? 'Enter valid email'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                decoration: textDec.copyWith(
                                  hintText: "Password :",
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                        print('pressed');
                                      });
                                    },
                                    icon: Icon(_obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                ),
                                validator: (val) => val!.length < 6
                                    ? 'Enter password 6+ chars long'
                                    : null,
                                obscureText: _obscureText,
                                onChanged: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(
                                    () {
                                      isDeleting = false;
                                    },
                                  );
                                },
                                child: const Text('cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  setState(
                                    () {
                                      isDeleting = true;
                                    },
                                  );
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  String result = await _auth
                                      .checkAccountCredentials(email, password);

                                  if (result == 'success') {
                                    print('user Id   $user');

                                    await DeleteUserData()
                                        .deleteImages(user!.uid);
                                    print('finish deleteImages');
                                    await DeleteUserData()
                                        .deleteAllTheUrls(user.uid);
                                    print('finish deleteAllTheUrls');
                                    await DeleteUserData()
                                        .deleteProfileImages(user.uid);
                                    print('finish deleteProfileImages');
                                    await DatabaseServices(uid: user.uid)
                                        .deleteUserAndSubcollections(user.uid);
                                    print('finish deleteUserAndSubcollections');
                                    await ChatServices()
                                        .deleteUserMessages(user.uid);
                                    print('finish deleting chats');
                                    await user.delete();
                                    print("finish deleting user");
                                    await _auth.signOuts();
                                    print("signing out");

                                    setState(
                                      () {
                                        isDeleting = false;

                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => Wrapper()),
                                            ((route) => false));
                                      },
                                    );

                                    print('finish deleteUserMessages');
                                  } else if (result == 'reauth_error') {
                                    setState(() {
                                      const snackBar = SnackBar(
                                          content: Text(
                                              'Invalid credentials. Please check  password.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isDeleting = false;
                                      print(
                                          ' Invalid credentials. Please check  password.');
                                    });
                                  } else if (result == 'email_not_found') {
                                    setState(() {
                                      const snackBar = SnackBar(
                                          content: Text(
                                              'This email address does not exist'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isDeleting = false;
                                      print(
                                          'This email address does not exist');
                                    });
                                  } else {
                                    setState(() {
                                      const snackBar = SnackBar(
                                          content: Text(
                                              'An error occurred while deleting the account.'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      isDeleting = false;
                                    });
                                  }
                                },
                                child: const Text(
                                  'Delete Account',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                  },
                );
              },
            );
          },
          child: const Text('delete account'),
        ),
      ),
    );
  }
}
