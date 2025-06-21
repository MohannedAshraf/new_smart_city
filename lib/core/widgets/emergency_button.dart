// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:citio/core/widgets/emergency_data.dart';
import 'package:citio/helper/api_emergency.dart';
import 'package:citio/models/emergency_model.dart';
import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  const EmergencyButton({
    super.key,
    required this.color,
    required this.emicon,
    required this.emname,
    required this.emergencyServiceId,
  });

  final Color color;
  final Widget emicon;
  final String emname;
  final String emergencyServiceId;

  void _showCountdownDialog(BuildContext context) {
    int countdown = 5;
    Timer? timer;
    bool isCancelled = false;
    BuildContext outerContext = context;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            // شغّل المؤقت هنا داخل الـ StatefulBuilder
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (countdown == 1 && !isCancelled) {
                t.cancel();
                Navigator.of(dialogContext).pop(); // Close dialog
                _sendEmergencyRequest(outerContext);
              }
              if (!isCancelled) {
                setState(() {
                  countdown--;
                });
              }
            });

            return AlertDialog(
              title: const Text("تأكيد البلاغ"),
              content: Text("سيتم إرسال البلاغ خلال $countdown ثانية..."),
              actions: [
                TextButton(
                  onPressed: () {
                    isCancelled = true;
                    timer?.cancel();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text("إلغاء"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _sendEmergencyRequest(BuildContext context) async {
    final request = EmergencyRequestModel(
      emergencyServiceId: emergencyServiceId,
      latitude: EmergencyFakeData.getRandomLatitude(),
      longitude: EmergencyFakeData.getRandomLongitude(),
      address: EmergencyFakeData.getRandomAddress(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final result = await EmergencyApiService.sendEmergency(request);

    Navigator.pop(context); // Close loading dialog

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result ?? "تم إرسال البلاغ بنجاح")));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountdownDialog(context),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showCountdownDialog(context),
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: emicon,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            emname,
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
