// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use
import 'package:citio/helper/api_profile.dart';
import 'package:citio/main.dart';
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1375,
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.01625),
              Center(
                child: Column(
                  children: [
                    Text(
                      user?.fullName ?? "بدون اسم",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.0325,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    Text(
                      'مستخدم',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.0375),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    "تعديل البيانات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.01875,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.0175,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    "تسجيل الخروج",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: MediaQuery.of(context).size.height * 0.0175,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.0175,
                    ),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03,
                      ),
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
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.0125,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.0375),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.015,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0025),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.01875,
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
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.005,
      ),
      child: const Divider(height: 1, color: Colors.grey),
    );
  }
}
