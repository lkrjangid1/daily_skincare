
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skincare/constants/lists.dart';

class RoutineTile extends StatelessWidget {
  final int index;
  final Iterable stepsData;
  final void Function()? onTap;
  const RoutineTile({
    Key? key,
    required this.index,
    required this.stepsData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Iterable currentStep = stepsData.where(
      (element) => element['type'] == skincareTypes[index]['key']!,
    );
    return ListTile(
      onTap: currentStep.isNotEmpty ? null : onTap,
      leading: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF2E8EB),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(12),
        child: currentStep.isNotEmpty
            ? const Icon(Icons.done)
            : const Icon(Icons.square_outlined),
      ),
      title: Text(skincareTypes[index]['name']!),
      subtitle: Text(
        skincareTypes[index]['description']!,
        style: const TextStyle(
          color: Color(0xff964F66),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentStep.isNotEmpty) ...[
            Text(
              DateFormat("hh:MM aa").format(DateTime.fromMillisecondsSinceEpoch(
                  currentStep.first['time'])),
              style: const TextStyle(
                color: Color(0xff964F66),
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 5),
          ],
          const Icon(Icons.camera_alt_outlined),
        ],
      ),
    );
  }
}
