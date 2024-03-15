import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skincare/constants/utils.dart';

class GetTodaySkinCareData {
  static Future<DocumentSnapshot<Map<String, dynamic>>> get() async {
    return FirebaseFirestore.instance
        .collection('skincare_database')
        .doc(
            "${FirebaseAuth.instance.currentUser!.uid}_${Utils.getTodayTimestamp()}")
        .get();
  }
}
