import 'package:cloud_firestore/cloud_firestore.dart';

Future<StripeData> fetchStripeData() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var ds = await firestore
      .collection('stripe_data')
      .doc('QvkA78Mnc1Tx6hths2Qy')
      .get();

  return StripeData(
      sub1priceId: ds.get('sub1priceId'), sub2priceId: ds.get('sub2priceId'));
}

class StripeData {
  String sub1priceId;
  String sub2priceId;
  StripeData({
    required this.sub1priceId,
    required this.sub2priceId,
  });
}
