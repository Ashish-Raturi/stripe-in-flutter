import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stripe/previous_purhcase.dart';
import 'package:stripe/service/fetch_product_details.dart';
import 'package:stripe/shared/checkout_page.dart';
import 'package:stripe/shared/show_loading.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool loadingPayment = false;
  @override
  Widget build(BuildContext context) {
    if (loadingPayment) return loading("Processing payment...");

    return FutureBuilder<List<ProductDetials>>(
        future: featchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return loading('Loading product details');
          }

          List<ProductDetials> productDetails = snapshot.data!;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  'SHOES STORE',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreviousPurchase(
                                      prodctDetailsLst: productDetails,
                                    )));
                      },
                      icon: Icon(
                        Icons.history,
                        color: Colors.black,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ))
                ],
              ),
              body: GridView.builder(
                  itemCount: productDetails.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.7, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    ProductDetials currentProduct =
                        productDetails.elementAt(index);
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: 170,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                        currentProduct.imageUrl))),
                            Text(
                              currentProduct.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              currentProduct.description,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs ' + currentProduct.price,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green),
                                    onPressed: () {
                                      showBuyBottomSheet(currentProduct);
                                    },
                                    child: Text('Buy'))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }));
        });
  }

  showBuyBottomSheet(ProductDetials pd) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18))),
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 200,
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 80, child: Image.network(pd.imageUrl)),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pd.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 20,
                              child: TextFormField(
                                initialValue: pd.quatity.toString(),
                                onChanged: (val) {
                                  setState(() {
                                    pd.quatity = int.tryParse(val) ?? 1;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SizedBox(
                            width: 5,
                          ),
                        ),
                        Text(
                          'Rs ' + pd.price,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () {
                              Navigator.pop(context);
                              buyStuff(pd);
                            },
                            child: Text('Pay ${calculateTotalPrice(pd)}')))
                  ],
                ),
              ),
            );
          });
        });
  }

  buyStuff(ProductDetials pd) async {
    setState(() {
      loadingPayment = true;
    });
    String userUid = FirebaseAuth.instance.currentUser!.uid;
    var docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('checkout_sessions')
        .add({
      'price': pd.priceId,
      'quantity': pd.quatity,
      'mode': 'payment',
      'success_url': 'https://success.com',
      'cancel_url': 'https://cancel.com'
    });

    docRef.snapshots().listen((ds) async {
      if (ds.exists) {
        //check any error
        var error;

        try {
          error = ds.get('error');
        } catch (e) {
          error = null;
        }

        if (error != null) {
          //show a dialog for error message
          print(error);
        } else {
          String url = ds.get('url');

          var res = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckoutPage(url: url)));

          if (res == 'success') {
            //payment successfull
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Payment Successfull'),
                    actions: [
                      TextButton(
                          child: Text('ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          } else {
            //payment failed

            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Payment failed'),
                    actions: [
                      TextButton(
                          child: Text('ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          }
        }

        setState(() {
          loadingPayment = false;
        });
      }
    });
  }

  calculateTotalPrice(ProductDetials pd) {
    double totalPrice;

    totalPrice = double.parse(pd.price) * pd.quatity;

    return totalPrice;
  }
}
