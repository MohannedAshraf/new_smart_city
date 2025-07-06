// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:citio/core/utils/mycolors.dart';
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

    // نصوص ثابتة - لإضافتها في ملف strings لاحقًا
    const String confirmTitle = "تأكيد البلاغ";
    const String cancelText = "إلغاء";
    const String successMessage = "تم إرسال البلاغ بنجاح";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
              if (countdown == 1 && !isCancelled) {
                t.cancel();
                Navigator.of(dialogContext).pop();
                _sendEmergencyRequest(outerContext);
              }
              if (!isCancelled) {
                setState(() {
                  countdown--;
                });
              }
            });

            return AlertDialog(
              backgroundColor: MyColors.white,
              title: const Text(confirmTitle),
              content: Text("سيتم إرسال البلاغ خلال $countdown ثانية..."),
              actions: [
                TextButton(
                  onPressed: () {
                    isCancelled = true;
                    timer?.cancel();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text(cancelText),
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
    double iconSize = MediaQuery.of(context).size.width * 0.10;
    double spacing = MediaQuery.of(context).size.height * 0.012;
    double fontSize = MediaQuery.of(context).size.width * 0.030;

    return GestureDetector(
      onTap: () => _showCountdownDialog(context),
      child: Column(
        children: [
          InkWell(
            onTap: () => _showCountdownDialog(context),
            borderRadius: BorderRadius.circular(iconSize),
            child: Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              child: emicon,
            ),
          ),
          SizedBox(height: spacing),
          Text(
            emname,
            style: TextStyle(fontSize: fontSize, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
