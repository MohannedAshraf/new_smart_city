// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api_delete_acc.dart';
import 'package:citio/helper/api_profile.dart';
import 'package:citio/main.dart';
import 'package:citio/models/profile_model.dart';
import 'package:citio/screens/edit_profile.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.accountDeleted)),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MyloginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text(AppStrings.deleteFailed)));
      }
    } catch (e) {
      print("❌ Error deleting account: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("${AppStrings.errorOccurred}$e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
          AppStrings.profileTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: width * 0.15,
                  backgroundImage:
                      (user?.imageUrl != null &&
                              user!.imageUrl!.trim().isNotEmpty)
                          ? NetworkImage(
                            "${Urls.cmsBaseUrl}${user!.imageUrl!.trim().startsWith('/') ? '' : '/'}${user!.imageUrl!.trim()}",
                          )
                          : const NetworkImage(
                            'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                          ),
                ),
              ),
              SizedBox(height: height * 0.015),
              Center(
                child: Column(
                  children: [
                    Text(
                      user?.fullName ?? AppStrings.noName,
                      style: TextStyle(
                        fontSize: width * 0.065,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      AppStrings.user,
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              _profileItem(
                icon: Icons.phone,
                color: Colors.blue,
                label: AppStrings.phoneNumber,
                value: user?.phoneNumber ?? AppStrings.unknown,
              ),
              _divider(),
              _profileItem(
                icon: Icons.email,
                color: Colors.green,
                label: AppStrings.email,
                value: user?.email ?? AppStrings.unknown,
              ),
              _divider(),
              _profileItem(
                icon: Icons.location_on,
                color: Colors.purple,
                label: AppStrings.address,
                value: user?.address ?? AppStrings.unknown,
              ),
              _divider(),
              _profileItem(
                icon: Icons.apartment,
                color: Colors.orange,
                label: AppStrings.building,
                value: user?.buildingNumber ?? "-",
              ),
              _divider(),
              _profileItem(
                icon: Icons.stairs,
                color: Colors.teal,
                label: AppStrings.floor,
                value: user?.floorNumber ?? "-",
              ),
              SizedBox(height: height * 0.03),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: Text(
                    AppStrings.editData,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.045,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
              SizedBox(height: height * 0.015),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: Text(
                    AppStrings.deleteAccount,
                    style: TextStyle(color: Colors.red, fontSize: width * 0.04),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: height * 0.02),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.012),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: width * 0.03,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: height * 0.004),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: width * 0.04,
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
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.005),
      child: const Divider(height: 1, color: Colors.grey),
    );
  }
}
