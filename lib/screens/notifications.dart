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
  String _selectedFilter = 'الكل';

  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.campaign,
      iconBackgroundColor: Colors.lightBlue.shade100,
      title: 'اجتماع مجلس المدينة غدًا',
      description:
          'انضم إلينا لاجتماع مجلس المدينة الشهري لمناقشة مشاريع البنية التحتية والمبادرات المجتمعية.',
      timeAgo: 'منذ ساعتين',
      category: 'updates',
    ),
    NotificationItem(
      icon: Icons.warning_amber,
      iconBackgroundColor: Colors.amber.shade100,
      title: 'تحذير من إغلاق الطريق - شارع الرئيسي',
      description:
          'تم حل مشكلة الحفرة التي أبلغت عنها في شارع الرئيسي. شكرًا لمساهمتك!',
      timeAgo: 'منذ 5 ساعات',
      category: 'alerts',
    ),
    NotificationItem(
      icon: Icons.card_giftcard,
      iconBackgroundColor: Colors.lightGreen.shade100,
      title: 'عرض خاص: خصم 20% على مواقف السيارات',
      description:
          'احصل على خصم 20% على موقفك التالي في وسط المدينة. العرض ساري حتى نهاية الشهر.',
      timeAgo: 'منذ يوم',
      category: 'offers',
    ),
    NotificationItem(
      icon: Icons.apartment,
      iconBackgroundColor: Colors.blue.shade100,
      title: 'افتتاح الحديقة الجديدة هذا الأسبوع',
      description:
          'اكتملت تجديدات حديقة سنترال! انضم إلينا للافتتاح الكبير مع موسيقى حية وشاحنات طعام.',
      timeAgo: 'منذ يومين',
      category: 'updates',
    ),
    NotificationItem(
      icon: Icons.check_circle_outline,
      iconBackgroundColor: Colors.deepPurple.shade100,
      title: 'تم حل المشكلة - إصلاح عمود الإنارة',
      description:
          'تم إصلاح عمود الإنارة المعطل في شارع أوك من قبل فريق الصيانة بنجاح.',
      timeAgo: 'منذ 3 أيام',
      category: 'alerts',
    ),
    NotificationItem(
      icon: Icons.local_offer,
      iconBackgroundColor: Colors.pink.shade100,
      title: 'عرض جديد لسكان المدينة',
      description:
          'استمتع بعرض خاص لسكان المدينة على بعض الخدمات البلدية هذا الأسبوع فقط!',
      timeAgo: 'منذ أسبوع',
      category: 'offers',
    ),
  ];

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'الكل') return _notifications;
    if (_selectedFilter == 'التحديثات') {
      return _notifications.where((n) => n.category == 'updates').toList();
    } else if (_selectedFilter == 'العروض') {
      return _notifications.where((n) => n.category == 'offers').toList();
    } else if (_selectedFilter == 'التنبيهات') {
      return _notifications.where((n) => n.category == 'alerts').toList();
    } else {
      return _notifications;
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                  });
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
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              });
            },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('الإشعارات'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child:
                _filteredNotifications.isEmpty
                    ? const Center(child: Text("لا توجد إشعارات حاليًا"))
                    : ListView.builder(
                      itemCount: _filteredNotifications.length, 
                      itemBuilder: (context, index) {
                        final item = _filteredNotifications[index];
                        return NotificationCard(
                          notification: item,
                          onTap: () {
                            setState(() {
                              item.isRead = true;
                            });
                          },
                        );
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
