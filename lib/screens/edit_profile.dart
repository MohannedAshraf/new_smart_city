// ignore_for_file: use_build_context_synchronously, avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:citio/core/utils/assets_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController(text: 'mohanned ashraf');
  final phoneController = TextEditingController(text: '01094605294');
  final emailController = TextEditingController(
    text: 'mohanned.ashraf@gmail.com',
  );
  final addressController = TextEditingController(
    text: '20 الزقازيق - الشرقيه',
  );
  final buildingController = TextEditingController(text: '15');
  final floorController = TextEditingController(text: 'الرابع');

  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', base64Image);

      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      try {
        final imageBytes = base64Decode(base64Image);
        final tempDir = Directory.systemTemp;
        final tempFile = await File(
          '${tempDir.path}/temp_image.jpg',
        ).writeAsBytes(imageBytes);
        setState(() => _imageFile = tempFile);
      } catch (e) {
        print('🟥 Error decoding image: $e');
      }
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("التقاط صورة بالكاميرا"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("اختيار من المعرض"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
    );
  }

  Widget _buildFormField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool isEmail = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          if (isEmail && !value.contains('@')) {
            return 'صيغة البريد غير صحيحة';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل البيانات"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _imageFile != null
                            ? FileImage(_imageFile!)
                            : const AssetImage(MyAssetsImage.logo)
                                as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: GestureDetector(
                      onTap: _showImageSourcePicker,
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildFormField(
                hint: "الإسم",
                icon: Icons.person,
                controller: nameController,
              ),
              _buildFormField(
                hint: "رقم الهاتف",
                icon: Icons.phone,
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildFormField(
                hint: "البريد الإلكتروني",
                icon: Icons.email,
                controller: emailController,
                isEmail: true,
              ),
              _buildFormField(
                hint: "العنوان",
                icon: Icons.location_on,
                controller: addressController,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildFormField(
                      hint: "المبنى",
                      icon: Icons.apartment,
                      controller: buildingController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildFormField(
                      hint: "الدور",
                      icon: Icons.stairs,
                      controller: floorController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    "حفظ التعديلات",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
