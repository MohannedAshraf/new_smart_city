import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int count;

  const TabItem({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final badgeSize = MediaQuery.of(context).size.width * 0.045;

    return Tab(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp),
          ),
          if (count > 0)
            Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                count > 9 ? "9+" : count.toString(),
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: badgeSize * 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
