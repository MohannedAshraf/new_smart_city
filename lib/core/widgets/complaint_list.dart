import 'package:citio/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅
import 'package:intl/intl.dart';

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class ComplaintList extends StatelessWidget {
  final List<Values> issues;
  final String type;

  const ComplaintList({super.key, required this.issues, required this.type});

  String getTimeAgo(String dateString) {
    try {
      final fixedDateString = dateString.replaceAllMapped(
        RegExp(r'([a-zA-Z]+ \d{1,2}),(\d{4})'),
        (match) => '${match[1]}, ${match[2]}',
      );

      final dateFormat = DateFormat("MMMM d, yyyy h:mm a", "en_US");
      final dateTime = dateFormat.parse(fixedDateString, true);

      final now = DateTime.now();
      final difference = now.difference(dateTime);
      if (difference.inSeconds < 60) {
        return "منذ لحظات";
      } else if (difference.inMinutes < 60) {
        return "منذ ${difference.inMinutes} دقيقة";
      } else if (difference.inHours < 24) {
        return "منذ ${difference.inHours} ساعة";
      } else if (difference.inDays < 7) {
        return "منذ ${difference.inDays} يوم";
      } else {
        final weeks = (difference.inDays / 7).floor();
        return "منذ $weeks أسبوع";
      }
    } catch (e) {
      return "منذ فترة";
    }
  }

  Widget buildTrailingWidget() {
    switch (type) {
      case 'inprogress':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.hourglass_top, size: 20.sp, color: Colors.orange),
            SizedBox(width: 4.w),
            Text(
              'قيد المراجعة',
              style: TextStyle(fontSize: 13.sp, color: Colors.orange),
            ),
          ],
        );
      case 'active':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.pending_actions, size: 20.sp, color: Colors.blue),
            SizedBox(width: 4.w),
            Text(
              'قيد الانتظار',
              style: TextStyle(fontSize: 13.sp, color: Colors.blue),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: 150.h,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            margin: EdgeInsets.symmetric(vertical: 8.h),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: issue.image != null
                        ? Image.network(
                            _baseUrl + issue.image!,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 40.sp),
                          )
                        : Image.network(
                            'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image, size: 40.sp),
                          ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          (type == 'inprogress')
                              ? 'تحت المراجعة'
                              : (type == 'active')
                                  ? getTimeAgo(issue.date)
                                  : (issue.date.isNotEmpty ? issue.date : ''),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: buildTrailingWidget(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
