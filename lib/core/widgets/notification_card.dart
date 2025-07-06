// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/project_strings.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        onTapMarkAsRead();
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width * 0.04),
                ),
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    Icon(icon, color: MyColors.themecolor),
                    SizedBox(width: width * 0.02),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: width * 0.038,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: width * 0.04,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: width * 0.015),
                        Text(
                          notification.createdAt.toLocal().toString().split(
                            '.',
                          )[0],
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.025),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  width * 0.03,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.012,
                              ),
                            ),
                            child: Text(
                              AppStrings.cancel,
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Share.share(
                                '${notification.title}\n\n${notification.body}',
                              );
                            },
                            icon: Icon(
                              Icons.share,
                              size: width * 0.045,
                              color: Colors.white,
                            ),
                            label: Text(
                              AppStrings.share,
                              style: TextStyle(
                                fontSize: width * 0.035,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  width * 0.03,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.012,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        );
      },
      child: Card(
        color: notification.isRead ? Colors.white : const Color(0xFFF1F6FF),
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.03),
        ),
        elevation: 0.5,
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.025),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(width * 0.025),
                ),
                child: Icon(
                  icon,
                  color: MyColors.themecolor,
                  size: width * 0.06,
                ),
              ),
              SizedBox(width: width * 0.04),
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
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: width * 0.02,
                            height: width * 0.02,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: width * 0.038,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: width * 0.03,
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
