import 'package:city/core/widgets/emergency_button.dart';
import 'package:city/screens/second_issues_page.dart';
import 'package:flutter/material.dart';

class IssueScreen extends StatelessWidget {
  const IssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const EmergencyButton(
            color: Colors.red,
            emicon: Icon(Icons.local_hospital, size: 80, color: Colors.white),
            emname: "إسعاف",
            emergencyServiceId: "1",
          ),
          const EmergencyButton(
            color: Colors.orange,
            emicon: Icon(Icons.fire_truck, size: 80, color: Colors.white),
            emname: "مطافي",
            emergencyServiceId: "2",
          ),
          const EmergencyButton(
            color: Colors.blue,
            emicon: Icon(Icons.local_police, size: 80, color: Colors.white),
            emname: "شرطة",
            emergencyServiceId: "3",
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const IssuesPage()),
              );
            },
            child: const Text(
              "تخطي ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
