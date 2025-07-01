// ignore_for_file: deprecated_member_use

import 'package:citio/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:share_plus/share_plus.dart';

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
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.04,
                  ), // ✅
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width * 0.05,
                  ), // ✅
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.025,
                              ), // ✅
                              decoration: BoxDecoration(
                                color: iconBgColor,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.025,
                                ), // ✅
                              ),
                              child: Icon(
                                icon,
                                color: MyColors.themecolor,
                                size:
                                    MediaQuery.of(context).size.height *
                                    0.0350, // ✅
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ), // ✅
                            Expanded(
                              child: Text(
                                notification.title,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height *
                                      0.02250, // ✅
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ), // ✅
                        Text(
                          notification.body,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.01875,
                          ), // ✅
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ), // ✅
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: MediaQuery.of(context).size.height * 0.02,
                              color: Colors.grey[600],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015,
                            ), // ✅
                            Text(
                              notification.createdAt.toLocal().toString().split(
                                '.',
                              )[0],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height *
                                    0.01625, // ✅
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ), // ✅
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed:
                                  () => Share.share(
                                    '${notification.title}\n\n${notification.body}',
                                  ),
                              icon: Icon(
                                Icons.share,
                                size:
                                    MediaQuery.of(context).size.height *
                                    0.02250,
                              ), // ✅
                              label: Text(
                                'مشاركة',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height *
                                      0.0175,
                                ), // ✅
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ), // ✅
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'إغلاق',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height *
                                      0.0175,
                                ), // ✅
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
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
        ), // ✅
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.03,
          ), // ✅
        ),
        elevation: 0.5,
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * 0.04,
          ), // ✅
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.025,
                ), // ✅
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.02,
                  ), // ✅
                ),
                child: Icon(
                  icon,
                  color: MyColors.themecolor,
                  size: MediaQuery.of(context).size.height * 0.03,
                ), // ✅
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.04), // ✅
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
                              fontSize:
                                  MediaQuery.of(context).size.height *
                                  0.02, // ✅
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: MediaQuery.of(context).size.width * 0.02,
                            height: MediaQuery.of(context).size.width * 0.02,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ), // ✅
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * 0.0175, // ✅
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ), // ✅
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.height * 0.015, // ✅
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
