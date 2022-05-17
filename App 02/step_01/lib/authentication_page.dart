import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stripe/color.dart';
import 'package:stripe/home_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return HomePage(
              uid: snapshot.data!.uid,
            );
          } else {
            return Scaffold(
              backgroundColor: c2,
              appBar: AppBar(
                title: Text(
                  'Login Page',
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                backgroundColor: c2,
                elevation: 0,
              ),
              body: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: c1),
                    onPressed: () {
                      //signin with google
                      signinWithGoogle();
                    },
                    child: Text('Signin With Google')),
              ),
            );
          }
        });
  }

  Future<void> signinWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final dynamic googleSigninAccount = await _googleSignIn.signIn();
    if (googleSigninAccount == null) {
      return;
    } else {
      try {
        final gsa = await googleSigninAccount.authentication;
        final credential = GoogleAuthProvider.credential(
            accessToken: gsa.accessToken, idToken: gsa.idToken);
        User? user = (await _auth.signInWithCredential(credential)).user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({'email': user.email, 'username': user.displayName});
        }
        return;
      } catch (e) {
        print(e.toString());
        return;
      }
    }
  }
}
