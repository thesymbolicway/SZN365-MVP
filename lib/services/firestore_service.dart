import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:szn365/consts/constant.dart';
import '../models/app_data.dart';

class FireBaseService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? getFirebaseUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<void> setUser(AppUser user) async {
    await _db.collection(Constant.USERS_TABLE).doc(user.id).set(user.toJson());
  }

  Future<AppUser?> getUser(String userId) async {
    final doc = await _db.collection(Constant.USERS_TABLE).doc(userId).get();

    if (doc.exists && doc.data() != null) {
      return AppUser.fromJson(doc.data()!);
    }
    return null;
  }

}
