// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use
import 'package:citio/helper/api_profile.dart';
import 'package:citio/models/profile_model.dart';
import 'package:citio/screens/edit_profile.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';

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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyloginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    user?.imageUrl ??
                        'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                  ),
                ),
              ),
              const SizedBox(height: 13),

              Center(
                child: Column(
                  children: [
                    Text(
                      user?.fullName ?? "بدون اسم",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
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
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "تعديل البيانات",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const EditProfile()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "تسجيل الخروج",
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
