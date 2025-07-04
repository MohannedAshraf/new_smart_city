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
        borderRadius: BorderRadius.circular(20.r),
      ),
      // width: MediaQuery.of(context).size.width - 30,
      //height: 200,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 16.h, 16.w, 12.h),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: MyColors.white,
                  radius: 14.r,
                  child: Icon(icon, color: MyColors.primary, size: 28.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    maxLines: 1,
                    title,

                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 18.sp,
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
            padding: EdgeInsets.fromLTRB(19.w, 0.h, 19.w, 20.h),
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
