import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skincare/constants/utils.dart';

class GetPast30DaysSkinCareData {
  static Future<QuerySnapshot<Map<String, dynamic>>> get() async {
    return FirebaseFirestore.instance
        .collection('skincare_database')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("date", isLessThanOrEqualTo: Utils.getTodayTimestamp())
        .where("date", isGreaterThan: Utils.get30DaysBeforeTimestamp())
        .get();
  }
}
