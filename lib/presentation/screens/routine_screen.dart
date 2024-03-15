import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skincare/constants/lists.dart';
import 'package:skincare/data/repo/add_today_skin_care_entry.dart';
import 'package:skincare/data/repo/get_today_skincare_data.dart';
import 'package:skincare/presentation/widgets/routine_tile.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});
  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  bool showProgress = false;
  @override
  void initState() {
    super.initState();
  }

  getStoragePermission() async {
    final permissionStatus = await Permission.storage.status;
    if (permissionStatus.isDenied) {
      await Permission.storage.request();
    } else if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  handleAddTodaySkincareEntry(String type) async {
    UploadTask? uploadTask;
    Reference? storageRef;
    (uploadTask, storageRef) = await AddTodaySkincareEntry.uploadImage();
    setState(() {
      showProgress = true;
    });
    if (uploadTask != null && storageRef != null) {
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            setState(() {
              showProgress = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Uploading paused"),
              ),
            );
            break;
          case TaskState.canceled:
            setState(() {
              showProgress = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Uploading cancel"),
              ),
            );
            break;
          case TaskState.error:
            setState(() {
              showProgress = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Error in uploading image"),
              ),
            );
            break;
          case TaskState.success:
            bool status = await AddTodaySkincareEntry.addDataToFirebase(
              type: type,
            );
            if (mounted) {
              if (status) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task completed successfully"),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Something went wrong, please try after some time."),
                  ),
                );
              }
            }
            setState(() {
              showProgress = false;
            });
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getStoragePermission();
    return Scaffold(
      backgroundColor: const Color(0xffFCF7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFCF7FA),
        elevation: 0,
        title: const Text(
          'Daily Skincare',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (showProgress) const LinearProgressIndicator(),
          Expanded(
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: GetTodaySkinCareData.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  List stepsData = [];
                  if (snapshot.data!.data() != null) {
                    stepsData.addAll(snapshot.data!.data()!['steps']);
                  }
                  return ListView.builder(
                    itemCount: skincareTypes.length,
                    itemBuilder: (context, index) {
                      return RoutineTile(
                        onTap: () => handleAddTodaySkincareEntry(
                            skincareTypes[index]['key']!),
                        stepsData: stepsData,
                        index: index,
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
