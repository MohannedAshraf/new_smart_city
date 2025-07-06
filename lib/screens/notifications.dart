// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
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
  final ScrollController _scrollController = ScrollController();

  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedFilter = AppStrings.filterAll;

  int _pageNumber = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoading &&
          _hasMore) {
        _loadNotifications();
      }
    });
  }

  String? _getCategoryKey(String label) {
    switch (label) {
      case AppStrings.filterUpdates:
        return 'Update';
      case AppStrings.filterOffers:
        return 'Offer';
      case AppStrings.filterAlerts:
        return 'Alert';
      default:
        return null;
    }
  }

  Future<void> _loadNotifications({bool reset = false}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (reset) {
      _pageNumber = 1;
      _notifications.clear();
      _hasMore = true;
    }

    try {
      final fetched = await _getNotificationsService.getNotifications(
        category: _getCategoryKey(_selectedFilter),
        pageNumber: _pageNumber,
        pageSize: _pageSize,
      );

      final readIds = await NotificationLocalStorage.getReadIds();
      for (var notification in fetched) {
        notification.isRead = readIds.contains(notification.id);
      }

      setState(() {
        _notifications.addAll(fetched);
        _isLoading = false;
        _pageNumber++;
        if (fetched.length < _pageSize) _hasMore = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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

  Widget _buildHeader(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.006,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: screenWidth * 0.02,
                  offset: Offset(0, screenHeight * 0.005),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black54,
                  size: screenWidth * 0.06,
                ),
                onChanged: (String? newValue) async {
                  if (newValue != null) {
                    setState(() => _selectedFilter = newValue);
                    await _loadNotifications(reset: true);
                  }
                },
                items:
                    [
                          AppStrings.filterAll,
                          AppStrings.filterUpdates,
                          AppStrings.filterOffers,
                          AppStrings.filterAlerts,
                        ]
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
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
              AppStrings.markAllAsRead,
              style: TextStyle(
                color: MyColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(double screenWidth, double screenHeight) {
    if (_isLoading && _notifications.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          '${AppStrings.errorOccurred}$_errorMessage',
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noNotifications,
          style: TextStyle(fontSize: screenWidth * 0.035),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _notifications.length + (_hasMore ? 1 : 0),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      itemBuilder: (context, index) {
        if (index < _notifications.length) {
          final notification = _notifications[index];
          return NotificationCard(
            notification: notification,
            onTapMarkAsRead: () => _markAsRead(notification),
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.notificationsTitle,
          style: TextStyle(fontSize: screenWidth * 0.045),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(screenWidth, screenHeight),
          Expanded(child: _buildBody(screenWidth, screenHeight)),
        ],
      ),
    );
  }
}
