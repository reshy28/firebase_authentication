import 'dart:developer';

import 'package:drawer/view/homescreen/homescreen.dart';
import 'package:drawer/view/registration_screen/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcntrlr = TextEditingController();
    TextEditingController passwordcntlr = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN SCREEN"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailcntrlr.text)) {
                    return null;
                  } else {
                    return "enter a valid email";
                  }
                },
                controller: emailcntrlr,
                decoration:
                    InputDecoration(enabledBorder: OutlineInputBorder()),
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                controller: passwordcntlr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailcntrlr.text,
                              password: passwordcntlr.text);
                      log(credential.user?.uid.toString() ?? "NO DATA");
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(" no user found that email"),
                          ),
                        );
                      } else if (e.code == 'wrong-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("wrong password provided for that user"),
                          ),
                        );
                      }
                    }
                  }

                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => Homescreen(),
                  //     ),
                  //     (route) => false);
                },
                child: Text("LOGIN "),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationScreen(),
                      ));
                },
                child: Text("Dont have account Register now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
