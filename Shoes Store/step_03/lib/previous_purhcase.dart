import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stripe/service/fetch_previous_purchase.dart';
import 'package:stripe/service/fetch_product_details.dart';
import 'package:stripe/shared/show_loading.dart';

class PreviousPurchase extends StatefulWidget {
  final List<ProductDetials> prodctDetailsLst;
  const PreviousPurchase({Key? key, required this.prodctDetailsLst})
      : super(key: key);

  @override
  State<PreviousPurchase> createState() => _PreviousPurchaseState();
}

class _PreviousPurchaseState extends State<PreviousPurchase> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PreviousPurchaseDetails>>(
        future: fetchPreviousPurchaseDetails(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false)
            return loading('Loading previous purchase...');

          List<PreviousPurchaseDetails> previousPurchaseLst = snapshot.data!;

          return FutureBuilder<List>(
              future: getDeiveredProductLst(),
              builder: (context, snapshot) {
                if (snapshot.hasData == false)
                  return loading('Loading delivered products...');

                List deliveredProductLst = snapshot.data!;

                return Scaffold(
                  appBar: AppBar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black),
                      title: Text(
                        'Purchase History',
                        style: TextStyle(color: Colors.black),
                      )),
                  body: ListView.builder(
                      itemCount: previousPurchaseLst.length,
                      itemBuilder: ((context, index) {
                        PreviousPurchaseDetails purchaseDetails =
                            previousPurchaseLst.elementAt(index);

                        bool productDelivered =
                            deliveredProductLst.contains(purchaseDetails.docId);

                        ProductDetials? productDetials;

                        for (ProductDetials pd in widget.prodctDetailsLst) {
                          if (purchaseDetails.priceRef.contains(pd.priceId)) {
                            productDetials = pd;
                            break;
                          }
                        }

                        if (productDetials == null) return SizedBox();
                        return ListTile(
                            leading: SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(productDetials.imageUrl)),
                            title: Text(
                              productDetials.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                productDelivered ? 'Delivered' : 'On the way'),
                            trailing: Text(
                              'Rs ' + purchaseDetails.pricePaid.toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ));
                      })),
                );
              });
        });
  }

  Future<List> getDeiveredProductLst() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String userUid = FirebaseAuth.instance.currentUser!.uid;
    var ds = await firestore.collection('users').doc(userUid).get();
    List deliveredLst = ds.get('delivered_products');
    return deliveredLst;
  }
}
