import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe/shared/show_loading.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email;
  late String password;

  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    if (showLoading) {
      loading('Loading...');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login Page',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.grey.shade300,
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18))),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.grey.shade300,
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18))),
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        loginUser();
                      },
                      child: Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(18)),
                        alignment: Alignment.center,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  loginUser() async {
    setState(() {
      showLoading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(email: email, password: password);
    setState(() {
      showLoading = false;
    });
    Navigator.pop(context);
  }
}
