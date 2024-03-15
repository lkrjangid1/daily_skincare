import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skincare/constants/utils.dart';
import 'package:skincare/data/repo/get_today_skincare_data.dart';

class AddTodaySkincareEntry {
  static Future<bool> addDataToFirebase({
    required String type,
  }) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> data =
          await GetTodaySkinCareData.get();
      if (data.data() != null) {
        await FirebaseFirestore.instance
            .collection('skincare_database')
            .doc(
                "${FirebaseAuth.instance.currentUser!.uid}_${Utils.getTodayTimestamp()}")
            .update({
          "steps": FieldValue.arrayUnion([
            {
              'type': type,
              'time': Utils.getCurrentTimestamp(),
            }
          ]),
        });
      } else {
        await FirebaseFirestore.instance
            .collection('skincare_database')
            .doc(
                "${FirebaseAuth.instance.currentUser!.uid}_${Utils.getTodayTimestamp()}")
            .set({
          "uid": FirebaseAuth.instance.currentUser!.uid,
          "date": Utils.getTodayTimestamp(),
          "steps": [
            {
              'type': type,
              'time': Utils.getCurrentTimestamp(),
            }
          ],
        });
      }

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<(UploadTask?, Reference?)> uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      PlatformFile files = result.files.first;
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask =
          storageRef.child("images/${files.name}").putFile(File(files.path!));
      return (uploadTask, storageRef);
    }
    return (null, null);
  }
}
