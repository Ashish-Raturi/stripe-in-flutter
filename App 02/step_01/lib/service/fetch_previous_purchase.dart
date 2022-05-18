import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreviousPurchaseDetails {
  double pricePaid;
  String priceRef;
  String docId;
  PreviousPurchaseDetails({
    required this.pricePaid,
    required this.priceRef,
    required this.docId,
  });
}

Future<List<PreviousPurchaseDetails>> fetchPreviousPurchaseDetails() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<PreviousPurchaseDetails> previousPurchase = [];

  String userUid = FirebaseAuth.instance.currentUser!.uid;

  var qs = await firestore
      .collection('users')
      .doc(userUid)
      .collection('payments')
      .get();

  for (var ds in qs.docs) {
    var status = ds.get('status');
    if (status == "succeeded") {
      double pricePaid = ds.get('amount') / 100;

      DocumentReference priceRef = ds.get('prices')[0];
      previousPurchase.add(PreviousPurchaseDetails(
          docId: ds.id, pricePaid: pricePaid, priceRef: priceRef.id));
    }
  }

  return previousPurchase;
}
