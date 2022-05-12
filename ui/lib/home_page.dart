import 'package:flutter/material.dart';
import 'package:color.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c2,
      appBar: AppBar(
        title: Text(
          'Hi, Ashish',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: c2,
        elevation: 0,
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
                    onPressed: () {},
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
                    onPressed: () {},
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
