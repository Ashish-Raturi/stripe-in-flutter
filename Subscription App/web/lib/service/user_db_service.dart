import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stripe/service/stripe_data.dart';

class UserDbService {
  final String uid;

  final StripeData? stripeData;
  UserDbService({required this.uid, this.stripeData});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<UserData> get fetchUserData {
    return firestore.collection('users').doc(uid).snapshots().map((ds) =>
        UserData(username: ds.get('username'), stripeId: ds.get('stripeId')));
  }

  Stream<SubscriptionStatus> get checkSubscriptionIsActive {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('subscriptions')
        .snapshots()
        .map((event) => checkUserHaveActiveSubscription(event));
  }

  SubscriptionStatus checkUserHaveActiveSubscription(QuerySnapshot qs) {
    for (var ds in qs.docs) {
      var status = ds.get('status'); // 'trialing', 'active'
      if (status == 'trialing' || status == 'active') {
        DocumentReference priceDocRef = ds.get('price');
        String currentPriceId = '';

        if (priceDocRef.id.contains(stripeData!.sub1priceId)) {
          currentPriceId = stripeData!.sub1priceId;
        } else if (priceDocRef.id.contains(stripeData!.sub2priceId)) {
          currentPriceId = stripeData!.sub2priceId;
        }
        return SubscriptionStatus(
            subIsActive: true, status: status, activePriceId: currentPriceId);
      }
    }
    return SubscriptionStatus(
        subIsActive: false, status: '', activePriceId: '');
  }
}

class UserData {
  String username;
  String stripeId;
  UserData({
    required this.username,
    required this.stripeId,
  });
}

class SubscriptionStatus {
  bool subIsActive;
  String status;
  String activePriceId;
  SubscriptionStatus({
    required this.subIsActive,
    required this.status,
    required this.activePriceId,
  });
}
