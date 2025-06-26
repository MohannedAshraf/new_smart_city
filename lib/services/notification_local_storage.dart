import 'package:shared_preferences/shared_preferences.dart';

class NotificationLocalStorage {
  static const _readKey = 'read_notifications';

  static Future<Set<String>> getReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_readKey) ?? [];
    return ids.toSet();
  }

  static Future<bool> isNotificationRead(String id) async {
    final readIds = await getReadIds();
    return readIds.contains(id);
  }

  static Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final readIds = await getReadIds();
    readIds.add(id);
    await prefs.setStringList(_readKey, readIds.toList());
  }

  static Future<void> markAllAsRead(List<String> allNotificationIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_readKey, allNotificationIds);
  }

  static Future<void> clearAllRead() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_readKey);
  }
}
