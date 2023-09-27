import 'package:flutter/material.dart';
import 'package:my_tips/services/auth.dart';
import 'package:my_tips/shared/constnts.dart';
import 'package:my_tips/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  const SignIn({super.key, required this.toggle});

  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthServices _auth = AuthServices();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: Container(),
                title: const Text("Sign In"),
                backgroundColor: const Color(0xFF112D60),
                elevation: 0.0,
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textDec.copyWith(hintText: "Email"),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter an Email' : null,
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
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result = await _auth.signInWithEmailAndPass(
                                email, password);
                            if (result == null) {
                              setState(() {
                                error = 'can not SignIn use valid Email';
                                loading = false;
                              });
                            }
                          }
                        },
                        child: const Text("LogIn"),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 18.0),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                widget.toggle();
                              });
                            },
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            )),
                      )
                    ]),
                  ),
                ),
              ),
            ),
          );
  }
}
