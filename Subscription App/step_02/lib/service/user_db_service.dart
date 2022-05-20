import 'package:cloud_firestore/cloud_firestore.dart';

class UserDbService {
  final String uid;
  UserDbService({
    required this.uid,
  });

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<UserData> get fetchUserData {
    return firestore.collection('users').doc(uid).snapshots().map((ds) =>
        UserData(username: ds.get('username'), stripeId: ds.get('stripeId')));
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
