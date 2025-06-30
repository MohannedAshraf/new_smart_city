// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:citio/helper/api_edit_profile.dart';
import 'package:citio/screens/profile.dart';
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
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final floorController = TextEditingController();

  File? _imageFile;
  String? savedImageUrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    nameController.text = prefs.getString('fullName') ?? '';
    phoneController.text = prefs.getString('phoneNumber') ?? '';
    emailController.text = prefs.getString('email') ?? '';
    addressController.text = prefs.getString('address') ?? '';
    buildingController.text = prefs.getString('buildingNumber') ?? '';
    floorController.text = prefs.getString('floorNumber') ?? '';
    savedImageUrl = prefs.getString('imageUrl');
    setState(() {});
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                            : (savedImageUrl != null &&
                                    savedImageUrl!.isNotEmpty
                                ? NetworkImage(
                                  "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io"
                                  "${savedImageUrl!.startsWith('/') ? '' : '/'}${savedImageUrl!}",
                                )
                                : const NetworkImage(
                                  'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                                )),
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
                child:
                    _isSaving
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isSaving = true);

                              final success =
                                  await ApiUpdateProfile.updateProfile(
                                    fullName: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                    address: addressController.text.trim(),
                                    buildingNumber:
                                        buildingController.text.trim(),
                                    floorNumber: floorController.text.trim(),
                                    imageFile: _imageFile,
                                  );

                              setState(() => _isSaving = false);

                              if (success == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Profile(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('فشل التحديث، حاول مرة أخرى'),
                                  ),
                                );
                              }
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
