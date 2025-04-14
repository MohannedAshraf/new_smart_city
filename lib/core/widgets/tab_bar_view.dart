import 'package:city/core/widgets/custom_card.dart';
import 'package:city/models/request.dart';
import 'package:city/services/get_requests_by_status.dart';
import 'package:flutter/material.dart';

class TabBarViewItem extends StatelessWidget {
  final String title;

  const TabBarViewItem({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Request>>(
      future: RequestsByStatus().getRequestsByStatus(status: title),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Request> requests = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: requests.length,
            itemBuilder: (context, index) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: CustomCard(request: requests[index]),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
