import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signupscreen extends StatelessWidget {
  Signupscreen({super.key});
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            TextField(controller: emailcontroller),
            TextField(controller: passwordcontroller),
            TextField(controller: confirmpasswordcontroller),
            ElevatedButton(
              onPressed: () async {
                if (passwordcontroller.text != confirmpasswordcontroller.text) {
                  print("password not match");
                  return;
                }
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: emailcontroller.text,
                        password: passwordcontroller.text,
                      );
                  //print(credential);
                  Navigator.pop(context);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Text('login'),
            ),
            SizedBox(height: 10),
            InkWell(onTap: () {}, child: Text('Sign up')),
          ],
        ),
      ),
    );
  }
}
