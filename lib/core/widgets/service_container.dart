import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.width * 0.05,
        ),
      ),
      // width: MediaQuery.of(context).size.width - 30,
      //height: 200,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.025,
              MediaQuery.of(context).size.height * 0.025,
              MediaQuery.of(context).size.width * 0.04,
              MediaQuery.of(context).size.height * 0.015,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.white,
                  radius: MediaQuery.of(context).size.width * 0.0350,
                  child: Icon(
                    icon,
                    color: MyColors.dodgerBlue,
                    size: MediaQuery.of(context).size.height * 0.0350,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    title,

                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: MediaQuery.of(context).size.height * 0.02250,
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
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.0475,
              0.h,
              MediaQuery.of(context).size.width * 0.0475,
              MediaQuery.of(context).size.height * 0.0250,
            ),
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
