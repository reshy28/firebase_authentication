import 'package:drawer/view/homescreen/loginScreen/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    final formkey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRATION SCREEN"),
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailcontroller.text)) {
                    return null;
                  } else {
                    return "enter a valid email";
                  }
                },
                controller: emailcontroller,
              ),
              SizedBox(
                height: 40,
              ),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                validator: (value) {
                  if (value != null && value.length >= 6) {
                    return null;
                  } else {
                    return "enter a valid password";
                  }
                },
                controller: passwordcontroller,
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    try {
                      final cred = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailcontroller.text,
                              password: passwordcontroller.text);
                      if (cred.user?.uid != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Failed to create account , try again"),
                          ),
                        );
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("The password provided is too weak"),
                          ),
                        );
                        //  print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "The account already exists for that email"),
                          ),
                        );
                        // /  print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text("REGISTER "),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                child: Text("Already have account LOGIN NOW"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
