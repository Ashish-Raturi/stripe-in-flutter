import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe/checkout_page.dart';
import 'package:stripe/color.dart';
import 'package:stripe/service/stripe_data.dart';
import 'package:stripe/service/user_db_service.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StripeData stripeData;

  bool loadingPayment = false;
  loading(String msg) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: UserDbService(uid: widget.uid).fetchUserData,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return loading('Loading User Data...');
          }

          UserData userData = snapshot.data!;
          return FutureBuilder<StripeData>(
              future: fetchStripeData(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return loading('Loading Stripe Data...');
                }

                stripeData = snapshot.data!;
                print(stripeData.sub1priceId);

                if (loadingPayment) return loading('Processing payment...');

                return Scaffold(
                  backgroundColor: c2,
                  appBar: AppBar(
                    title: Text(
                      'Hi, ${userData.username}',
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: c2,
                    elevation: 0,
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                          },
                          child: Text('Logout'))
                    ],
                  ),
                  body: Container(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          monthlySubTile(),
                          SizedBox(
                            height: 10,
                          ),
                          yearlySubTile(),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  monthlySubTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: c1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Starter Plan',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '\$ 1999.00',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 26),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(Icons.done, color: Colors.white),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\Unlimited For 1 Month',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Commitments - Cancel Anytime',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () async {
                      setState(() {
                        loadingPayment = true;
                      });
                      DocumentReference docRef = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(widget.uid)
                          .collection('checkout_sessions')
                          .add({
                        'price': stripeData.sub1priceId,
                        'success_url': 'https://success.com',
                        'cancel_url': 'https://cancel.com',
                      });

                      docRef.snapshots().listen((ds) async {
                        if (ds.exists) {
                          //checking error
                          var error;

                          try {
                            error = ds.get('error');
                          } catch (e) {
                            error = null;
                          }

                          if (error != null) {
                            //we got an error
                            print(error);

                            setState(() {
                              loadingPayment = false;
                            });
                          } else {
                            var url = ds.get('url');

                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutPage(url: url)));

                            if (res == 'sucess') {
                              print('payment completed');
                              setState(() {
                                loadingPayment = false;
                              });
                              //payment completed
                            } else {
                              print('payment failed');
                              //payment failed
                              setState(() {
                                loadingPayment = false;
                              });
                            }
                          }
                        }
                      });
                    },
                    child: Text(
                      'Choose Plan',
                      style: TextStyle(
                          color: c1, fontWeight: FontWeight.w900, fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                '1 Month Auto Renewal Subscription Plan',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  yearlySubTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pro Plan',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '\$ 3599.00',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 26),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.done,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Icon(
                        Icons.done,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '\Unlimited For 1 Year',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'No Commitments - Cancel Anytime',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: c1),
                    onPressed: () async {
                      setState(() {
                        loadingPayment = true;
                      });
                      DocumentReference docRef = await FirebaseFirestore
                          .instance
                          .collection('users')
                          .doc(widget.uid)
                          .collection('checkout_sessions')
                          .add({
                        'price': stripeData.sub2priceId,
                        'success_url': 'https://success.com',
                        'cancel_url': 'https://cancel.com',
                      });

                      docRef.snapshots().listen((ds) async {
                        if (ds.exists) {
                          //checking error
                          var error;

                          try {
                            error = ds.get('error');
                          } catch (e) {
                            error = null;
                          }

                          if (error != null) {
                            //we got an error
                            print(error);

                            setState(() {
                              loadingPayment = false;
                            });
                          } else {
                            var url = ds.get('url');

                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CheckoutPage(url: url)));

                            if (res == 'sucess') {
                              print('payment completed');
                              setState(() {
                                loadingPayment = false;
                              });
                              //payment completed
                            } else {
                              print('payment failed');
                              //payment failed
                              setState(() {
                                loadingPayment = false;
                              });
                            }
                          }
                        }
                      });
                    },
                    child: Text(
                      'Choose Plan',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                '1 Year Auto Renewal Subscription Plan',
                style: TextStyle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
