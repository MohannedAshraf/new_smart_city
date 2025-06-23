import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';

class ServiceContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> content;
  const ServiceContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      // width: MediaQuery.of(context).size.width - 30,
      //height: 200,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 16, 16, 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.white,
                  radius: 14,
                  child: Icon(icon, color: MyColors.dodgerBlue, size: 28),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    title,

                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    //maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(19, 0, 19, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: content,
            ),
          ),
        ],
      ),
    );
  }
}
