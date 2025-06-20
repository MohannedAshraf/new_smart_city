import 'package:flutter/material.dart';
import 'package:city/core/utils/mycolors.dart';

class NotificationItem {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final String timeAgo;

  NotificationItem({
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.timeAgo,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0.5, // Subtle shadow for card separation
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with colored background
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: notification.iconBackgroundColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                notification.icon,
                color: MyColors.themecolor, // Use your custom theme color for the icon
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Description
                  Text(
                    notification.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  // Time Ago
                  Text(
                    notification.timeAgo,
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
    );
  }
}