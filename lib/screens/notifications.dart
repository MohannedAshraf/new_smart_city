// ignore_for_file: deprecated_member_use

import 'package:citio/core/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../services/get_notification.dart';
import '../services/notification_local_storage.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<Notifications> {
  final GetNotifications _getNotificationsService = GetNotifications();

  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;

  String _selectedFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  /// ✅ ترجمة التسمية إلى قيمة `category` المناسبة
  String? _getCategoryKey(String label) {
    switch (label) {
      case 'التحديثات':
        return 'Update';
      case 'العروض':
        return 'Offer';
      case 'التنبيهات':
        return 'Alert';
      default:
        return null;
    }
  }

  Future<void> _loadNotifications({String? category}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final notifications = await _getNotificationsService.getNotifications(
        category: category,
      );

      final readIds = await NotificationLocalStorage.getReadIds();
      for (var notification in notifications) {
        notification.isRead = readIds.contains(notification.id);
      }

      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  List<NotificationModel> get _filteredNotifications {
    if (_selectedFilter == 'الكل') return _notifications;

    final categoryKey = _getCategoryKey(_selectedFilter);
    return _notifications.where((n) => n.category == categoryKey).toList();
  }

  Future<void> _markAllAsRead() async {
    final allIds = _notifications.map((n) => n.id).toList();
    await NotificationLocalStorage.markAllAsRead(allIds);
    setState(() {
      for (var n in _notifications) {
        n.isRead = true;
      }
    });
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (!notification.isRead) {
      await NotificationLocalStorage.markAsRead(notification.id);
      setState(() {
        notification.isRead = true;
      });
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    setState(() {
                      _selectedFilter = newValue;
                    });
                    await _loadNotifications(
                      category: _getCategoryKey(newValue),
                    );
                  }
                },
                items:
                    ['الكل', 'التحديثات', 'العروض', 'التنبيهات']
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'تحديد الكل كمقروء',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('حدث خطأ: $_errorMessage'));
    }

    if (_filteredNotifications.isEmpty) {
      return const Center(child: Text('لا توجد إشعارات حاليًا'));
    }

    return ListView.builder(
      itemCount: _filteredNotifications.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return NotificationCard(
          notification: notification,
          onTap: () => _markAsRead(notification),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Column(children: [_buildHeader(), Expanded(child: _buildBody())]),
    );
  }
}
