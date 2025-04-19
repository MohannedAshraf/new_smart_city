import 'dart:io';
import 'package:city/core/utils/assets_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // هنا ممكن تطبع أو تسجل الخطأ، لكن مش هنعمل حاجة عشان مفيش استثناء يظهر
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 211, 158, 139),
                  radius: 60,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage(MyAssetsImage.logo)
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 3,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 15,
                    child: Center(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 15,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'أحمد محمود',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileItem(
                      icon: Icons.phone,
                      title: 'رقم التليفون',
                      value: '0123456789',
                    ),
                    Divider(),
                    ProfileItem(
                      icon: Icons.email,
                      title: 'البريد الإلكتروني',
                      value: 'ahmed@email.com',
                    ),
                    Divider(),
                    ProfileItem(
                      icon: Icons.location_on,
                      title: 'العنوان',
                      value: 'الزقازيق - الشرقية',
                    ),
                    Divider(),
                    ProfileItem(
                      icon: Icons.home,
                      title: 'رقم المبنى',
                      value: '15',
                    ),
                    Divider(),
                    ProfileItem(
                      icon: Icons.apartment,
                      title: 'رقم الدور',
                      value: '3',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfile()),
                  );
                },
                child: const Text(
                  'تعديل البيانات',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ),
      ],
    );
  }
}
