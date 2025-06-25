// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      try {
        final imageBytes = base64Decode(base64Image);
        final tempDir = Directory.systemTemp;
        final tempFile = await File(
          '${tempDir.path}/temp_profile.jpg',
        ).writeAsBytes(imageBytes);
        setState(() {
          _profileImageFile = tempFile;
        });
      } catch (e) {
        print('خطأ في تحميل الصورة: $e');
      }
    }
  }

  Future<void> _deleteProfile(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyloginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          _profileImageFile != null
                              ? FileImage(_profileImageFile!)
                              : const AssetImage(MyAssetsImage.logo)
                                  as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 13),

                  const Center(
                    child: Column(
                      children: [
                        Text(
                          'mohanned ashraf',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'مستخدم',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  _profileItem(
                    icon: Icons.phone,
                    color: Colors.blue,
                    label: 'رقم  الهاتف ',
                    value: '01094605294',
                  ),
                  _divider(),
                  _profileItem(
                    icon: Icons.email,
                    color: Colors.green,
                    label: 'البريد الإكتروني ',
                    value: 'moahanned.ashraf@gmail.com',
                  ),
                  _divider(),
                  _profileItem(
                    icon: Icons.location_on,
                    color: Colors.purple,
                    label: 'العنوان',
                    value: '20 الزقازيق - الشرقيه',
                  ),
                  _divider(),
                  _profileItem(
                    icon: Icons.apartment,
                    color: Colors.orange,
                    label: 'Building',
                    value: 'A-15',
                  ),
                  _divider(),
                  _profileItem(
                    icon: Icons.stairs,
                    color: Colors.teal,
                    label: 'الدور',
                    value: 'الثاني ',
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        "تعديل البيانات ",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfile(),
                          ),
                        );

                        if (result == true) {
                          await _loadProfileImage(); // تحديث الصورة بعد التعديل مباشرة
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        "حذف  الحساب",
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _deleteProfile(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(height: 1, color: Colors.grey),
    );
  }
}
