import 'package:city/core/utils/variables.dart';
import 'package:city/models/request.dart';
import 'package:flutter/material.dart';

var icons = {
  'Completed': 'https://cdn-icons-png.flaticon.com/128/14025/14025537.png',
  'Pending': 'https://cdn-icons-png.flaticon.com/128/16261/16261670.png',
  'Rejected': 'https://cdn-icons-png.flaticon.com/128/11373/11373685.png',
};

// ignore: must_be_immutable
class CustomCard extends StatelessWidget {
  CustomCard({required this.request, required this.cardTitle, super.key});
  Request request;
  String cardTitle;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: MyColors.white,
      shadowColor: MyColors.white,
      surfaceTintColor: MyColors.white,

      child: Container(
        padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
        height: 100,
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    icons[cardTitle] ??
                        'https://www.flaticon.com/free-icon/broken-image_13434972',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 2, 15, 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          request.serviceName,
                          style: const TextStyle(
                            color: MyColors.fontcolor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // SizedBox(width: 160),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            '${request.requestStatus}\n${request.responseText}',
                            style: const TextStyle(
                              color: MyColors.fontcolor,
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  request.requestDate,
                  style: const TextStyle(
                    color: Color.fromRGBO(134, 133, 133, 1),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
