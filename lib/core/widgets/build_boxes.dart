// ignore_for_file: deprecated_member_use

import 'package:citio/models/most_requested_services.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BuildBoxes extends StatelessWidget {
  BuildBoxes({required this.title, super.key});
  String title;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MostRequested>>(
      future: MostRequestedServices().getMostRequestedServices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MostRequested> data = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 100.0, // Height of the box row
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length, // Number of boxes
                  itemBuilder: (context, index) {
                    return Container(
                      width: 90.0, // Width of each box
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Same color as the background
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          data[index].serviceName,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0), // Space between rows
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
