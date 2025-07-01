// ignore_for_file: deprecated_member_use

import 'package:citio/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ مهم

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTapMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTapMarkAsRead,
  });

  IconData _getIcon(String category) {
    switch (category.toLowerCase()) {
      case 'alert':
        return Icons.warning_amber_rounded;
      case 'offer':
        return Icons.local_offer_outlined;
      case 'update':
        return Icons.campaign;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconBackgroundColor(String category) {
    switch (category.toLowerCase()) {
      case 'alert':
        return Colors.amber.shade100;
      case 'offer':
        return Colors.pink.shade100;
      case 'update':
        return Colors.lightBlue.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 60) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      return 'منذ ${difference.inHours} ساعة';
    } else {
      return 'منذ ${difference.inDays} يوم';
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon(notification.category);
    final iconBgColor = _getIconBackgroundColor(notification.category);
    final timeAgo = _formatTimeAgo(notification.createdAt);

    return GestureDetector(
      onTap: () {
        onTapMarkAsRead();
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r), // ✅
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w), // ✅
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r), // ✅
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(10.r), // ✅
                          ),
                          child: Icon(
                            icon,
                            color: MyColors.themecolor,
                            size: 28.sp, // ✅
                          ),
                        ),
                        SizedBox(width: 12.w), // ✅
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 18.sp, // ✅
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h), // ✅
                    Text(
                      notification.body,
                      style: TextStyle(fontSize: 15.sp), // ✅
                    ),
                    SizedBox(height: 16.h), // ✅
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 6.w), // ✅
                        Text(
                          notification.createdAt
                              .toLocal()
                              .toString()
                              .split('.')[0],
                          style: TextStyle(
                            fontSize: 13.sp, // ✅
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h), // ✅
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => Share.share(
                            '${notification.title}\n\n${notification.body}',
                          ),
                          icon: Icon(Icons.share, size: 18.sp), // ✅
                          label: Text(
                            'مشاركة',
                            style: TextStyle(fontSize: 14.sp), // ✅
                          ),
                        ),
                        SizedBox(width: 8.w), // ✅
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'إغلاق',
                            style: TextStyle(fontSize: 14.sp), // ✅
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: Card(
        color: notification.isRead ? Colors.white : const Color(0xFFF1F6FF),
        margin: EdgeInsets.symmetric(vertical: 8.h), // ✅
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r), // ✅
        ),
        elevation: 0.5,
        child: Padding(
          padding: EdgeInsets.all(16.w), // ✅
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.r), // ✅
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8.r), // ✅
                ),
                child: Icon(icon, color: MyColors.themecolor, size: 24.sp), // ✅
              ),
              SizedBox(width: 16.w), // ✅
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp, // ✅
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h), // ✅
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14.sp, // ✅
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h), // ✅
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12.sp, // ✅
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
