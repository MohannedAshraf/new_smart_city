import 'package:citio/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';


class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
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
      onTap: onTap,
      child: Card(
        color: notification.isRead ? Colors.white : const Color(0xFFF1F6FF),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(icon, color: MyColors.themecolor),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        fontSize: 12.0,
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
