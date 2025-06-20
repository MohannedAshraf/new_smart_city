
import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:city/main.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<Notifications> {
  String _selectedFilter = 'All Notifications';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.campaign,
      iconBackgroundColor: Colors.lightBlue.shade100,
      title: 'City Council Meeting Tomorrow',
      description:
          'Join us for the monthly city council meeting to discuss upcoming infrastructure projects and community initiatives.',
      timeAgo: '2 hours ago',
    ),
    NotificationItem(
      icon: Icons.warning_amber,
      iconBackgroundColor: Colors.amber.shade100,
      title: 'Road Closure Update - Main St',
      description:
          'Your reported pothole issue on Main Street has been resolved. Thank you for helping improve our roads!',
      timeAgo: '5 hours ago',
    ),
    NotificationItem(
      icon: Icons.card_giftcard,
      iconBackgroundColor: Colors.lightGreen.shade100,
      title: 'Special Offer: 20% Off Parking',
      description:
          'Get 20% off your next parking session at downtown meters. Valid until the end of this month.',
      timeAgo: '1 day ago',
    ),
    NotificationItem(
      icon: Icons.apartment,
      iconBackgroundColor: Colors.blue.shade100,
      title: 'New Park Opening This Weekend',
      description:
          'Central Park renovation is complete! Join us for the grand reopening celebration with live music and food trucks.',
      timeAgo: '2 days ago',
    ),
    NotificationItem(
      icon: Icons.check_circle_outline,
      iconBackgroundColor: Colors.deepPurple.shade100,
      title: 'Issue Resolved - Streetlight Repair',
      description:
          'The broken streetlight you reported on Oak Avenue has been successfully repaired by our maintenance team.',
      timeAgo: '3 days ago',
    ),
    NotificationItem(
      icon: Icons.error_outline,
      iconBackgroundColor: Colors.red.shade100,
      title: 'Water Service Maintenance',
      description:
          'Scheduled water service maintenance in your area has been completed. Normal service has been restored.',
      timeAgo: '1 week ago',
    ),
  ];

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<String>(
            value: _selectedFilter,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: ['All Notifications', 'Unread', 'Archived']
                .map((value) => DropdownMenuItem(
                      value: value,
                      child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ))
                .toList(),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _notifications.isEmpty
                ? const Center(child: Text("لا توجد إشعارات حاليًا"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(notification: _notifications[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: MyColors.themecolor,
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}
