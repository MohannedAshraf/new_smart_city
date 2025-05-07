// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/material.dart';
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
    required String emergencyServiceId,
  });
  final Color color;
  final Widget emicon;
  final String emname;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          emicon,
          const SizedBox(height: 10),
          Text(
            emname,
            style: const TextStyle(fontSize: 35, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
