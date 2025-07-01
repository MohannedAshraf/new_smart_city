import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:citio/core/utils/variables.dart';

class TabItem extends StatelessWidget {
  final String title;
  //final int count;
  const TabItem({
    super.key,
    required this.title,
    //required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
