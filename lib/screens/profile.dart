// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:citio/helper/api_delete_acc.dart';
import 'package:citio/helper/api_profile.dart';
import 'package:citio/main.dart';
import 'package:citio/models/profile_model.dart';
import 'package:citio/screens/edit_profile.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileModel? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final data = await ApiProfileHelper.fetchProfile();
      setState(() {
        user = data;
        _isLoading = false;
      });
    } catch (e) {
      print("⚠️ Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteProfile(BuildContext context) async {
    try {
      final response = await ApiDeleteAccountHelper.deleteMyAccount();

      if (response.isSuccess == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", "");
        await prefs.setString("refreshToken", "");

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ تم حذف الحساب بنجاح")));

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyloginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ فشل حذف الحساب")));
      }
    } catch (e) {
      print("❌ Error deleting account: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ حصل خطأ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          },
        ),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55.r,
                  backgroundImage:
                      (user?.imageUrl != null &&
                              user!.imageUrl!.trim().isNotEmpty)
                          ? NetworkImage(
                            "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io"
                            "${user!.imageUrl!.trim().startsWith('/') ? '' : '/'}${user!.imageUrl!.trim()}",
                          )
                          : const NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                          ),
                ),
              ),
              SizedBox(height: 13.h),
              Center(
                child: Column(
                  children: [
                    Text(
                      user?.fullName ?? "بدون اسم",
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'مستخدم',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              _profileItem(
                icon: Icons.phone,
                color: Colors.blue,
                label: 'رقم الهاتف',
                value: user?.phoneNumber ?? "غير متوفر",
              ),
              _divider(),
              _profileItem(
                icon: Icons.email,
                color: Colors.green,
                label: 'البريد الإلكتروني',
                value: user?.email ?? "غير متوفر",
              ),
              _divider(),
              _profileItem(
                icon: Icons.location_on,
                color: Colors.purple,
                label: 'العنوان',
                value: user?.address ?? "غير متوفر",
              ),
              _divider(),
              _profileItem(
                icon: Icons.apartment,
                color: Colors.orange,
                label: 'Building',
                value: user?.buildingNumber ?? "-",
              ),
              _divider(),
              _profileItem(
                icon: Icons.stairs,
                color: Colors.teal,
                label: 'الدور',
                value: user?.floorNumber ?? "-",
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    "تعديل البيانات",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfile(user: user!),
                      ),
                    );
                    if (result == true) {
                      _loadProfileData();
                    }
                  },
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    "حذف الحساب",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  onPressed: () => _deleteProfile(context),
                ),
              ),
            ],
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15.sp,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: const Divider(height: 1, color: Colors.grey),
    );
  }
}
