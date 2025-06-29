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
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconBgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, color: MyColors.themecolor, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            notification.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      notification.body,
                      style: const TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(
                          '${notification.createdAt.toLocal().toString().split('.')[0]}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => Share.share(
                            '${notification.title}\n\n${notification.body}',
                          ),
                          icon: const Icon(Icons.share, size: 18),
                          label: const Text('مشاركة'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('إغلاق'),
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
