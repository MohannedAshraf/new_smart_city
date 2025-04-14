import 'package:city/core/utils/variables.dart';
import 'package:city/models/request.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  CustomCard({
    required this.request,
    super.key,
  });
  Request request;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      surfaceTintColor: Colors.grey,
      shadowColor: MyColors.themecolor,
      elevation: 4,
      child: ListTile(
        title: Text(request.serviceName),
        subtitle: Text(
            '${request.requestStatus}\n${request.responseStatus}\n${request.responseText}\n${request.requestDate}'),
      ),
    );
  }
}
