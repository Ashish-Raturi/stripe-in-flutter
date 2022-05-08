import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe/home_page.dart';

import 'color.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            //homepage
            return HomePage();
          }

          return Scaffold(
            backgroundColor: c2,
            appBar: AppBar(
              title: Text('Signin Page', style: TextStyle(color: Colors.black)),
              backgroundColor: c2,
              elevation: 0,
              centerTitle: true,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(hintText: 'Email'),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Password'),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: c1),
                        onPressed: () {
                          registerWithEmailAndPassword();
                        },
                        child: Text('Register')),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future registerWithEmailAndPassword() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        User user = userCredential.user!;
        print(user.email);

        FirebaseFirestore firestore = FirebaseFirestore.instance;

        firestore
            .collection('users')
            .doc(user.uid)
            .set({'email': user.email, 'username': 'Ashish'});
      }
    } catch (e) {}
  }
}
