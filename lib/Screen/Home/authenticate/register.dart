import 'package:flutter/material.dart';

import 'package:my_tips/Screen/Home/authenticate/check_connection.dart';

import 'package:my_tips/selectingPhoto/ImageStatus/profilePicture.dart';
import 'package:my_tips/services/Database.dart';
import 'package:my_tips/services/auth.dart';
import 'package:my_tips/shared/constnts.dart';

import '../../../selectingPhoto/ImageStatus/saveImage.dart';

class Register extends StatefulWidget {
  final Function toggle;

  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String name = '';
  String password = "";
  String error = '';
  String selectedImage = '';
  bool _obscureText = true;
  late int phoneNumber;

  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: const Text("SignUp"),
          backgroundColor: const Color(0xFF112D60),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  ProfilePicture(
                    onImageSelected: (imagePath) {
                      print("SELECTED IMAGEEEJJJJJ $selectedImage ");
                      setState(() {
                        if (selectedImage.isEmpty) {
                          selectedImage = imagePath;
                          print("SELECTED IMAGEEE $selectedImage ");
                        }
                      });
                      print("SELECTED IMAGEEEDDDDDD $selectedImage ");
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: textDec.copyWith(hintText: "Name :"),
                    validator: (val) => val!.isEmpty ? 'Enter Your Name' : null,
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: textDec.copyWith(
                        hintText: "Phone number :", prefixText: "+255"),
                    validator: (val) {
                      if (val!.isEmpty || val.length == 13) {
                        return "Enter Your Phone number not less than 12 digits";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      try {
                        setState(() {
                          phoneNumber = int.parse(val.replaceAll("+", ""));
                        });
                      } catch (e) {
                        setState(() {
                          phoneNumber = 0;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textDec.copyWith(hintText: "Email :"),
                    validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return TextFormField(
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
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    color: const Color(0xffff5722),
                    onPressed: () async {
                      isPressed = true;

                      dynamic connection =
                          await CheckConnection().checkInternetConnection();
                      print('connection $connection');
                      if (connection == 'wifi' ||
                          connection == 'mobile' ||
                          connection == 'vpn' ||
                          connection == 'ethernet') {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result = await _auth.registerWithEmailAndPass(
                              email, password);
                          if (result == null) {
                            setState(() {
                              error = 'use valid Email';
                              loading = false;
                            });
                          } else if (result != null) {
                            try {
                              print("SELECTED IMAGE UPLOO $selectedImage");
                              String? senderUid = _auth.getCurrentUID();
                              String imageUrl = await SaveImageProfile()
                                  .uploadImageToStorage(selectedImage);
                              await DatabaseServices(uid: senderUid!)
                                  .updateProfileInfo(
                                      name, phoneNumber, imageUrl);
                            } catch (e) {
                              print('an error happen here $e');
                            }
                          }
                        }
                      } else {
                        const snackBar =
                            SnackBar(content: Text('no internet connection'));
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
                      }
                    },
                    child: const Text("Register"),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          widget.toggle();
                        });
                      },
                      child: const Text(
                        'LogIn',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
