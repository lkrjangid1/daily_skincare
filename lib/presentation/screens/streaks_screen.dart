import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skincare/constants/utils.dart';
import 'package:skincare/data/repo/get_past_30_days_skin_care_data.dart';
import 'package:skincare/presentation/widgets/streak_graph.dart';

class StreaksScreen extends StatefulWidget {
  const StreaksScreen({super.key});
  @override
  State<StreaksScreen> createState() => _StreaksScreenState();
}

class _StreaksScreenState extends State<StreaksScreen> {
  
  int checkStreakCount(List<QueryDocumentSnapshot> data) {
    int streak = 0;
    for (int i = 1; i <= 30; i++) {
      if (data[i]['date'] != null) {
        if (data
            .where(
              (element) => element['date'] == Utils.getNDaysBeforeTimestamp(i),
            )
            .isNotEmpty) {
          streak += 1;
        } else {
          break;
        }
      }
    }
    return streak;
  }

  List<FlSpot> createStreakGraph(List<QueryDocumentSnapshot> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 30; i++) {
      Iterable d = data.where(
        (element) => element['date'] == Utils.getNDaysBeforeTimestamp(i),
      );
      if (d.isNotEmpty) {
        spots.add(FlSpot(
          (30 - i).toDouble(),
          d.first['steps'].length.toDouble(),
        ));
      } else {
        spots.add(FlSpot(
          (30 - i).toDouble(),
          0,
        ));
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCF7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffFCF7FA),
        elevation: 0,
        title: const Text(
          'Streaks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: GetPast30DaysSkinCareData.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Today's Goal: 3 streak days",
                      style:
                          TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffF2E8EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Streak Days",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(
                            snapshot.data!.docs.length.toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Daily Streak",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      checkStreakCount(snapshot.data!.docs).toString(),
                      style: const TextStyle(
                          fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const Row(
                      children: [
                        Text(
                          "Last 30 Days",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff964F66),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "+100%",
                          style: TextStyle(fontSize: 16, color: Colors.green),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    StreakGraph(spots: createStreakGraph(snapshot.data!.docs)),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Keep it up! You're on a roll.",
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffF2E8EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                          child: Text(
                        "Get Started",
                        style: TextStyle(fontSize: 17),
                      )),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
    );
  }
}
