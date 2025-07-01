// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:citio/helper/api_edit_profile.dart';
import 'package:citio/models/profile_model.dart';
import 'package:citio/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  final ProfileModel user;
  const EditProfile({super.key, required this.user});

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
    nameController.text = widget.user.fullName ?? '';
    phoneController.text = widget.user.phoneNumber ?? '';
    emailController.text = widget.user.email ?? '';
    addressController.text = widget.user.address ?? '';
    buildingController.text = widget.user.buildingNumber ?? '';
    floorController.text = widget.user.floorNumber ?? '';
    savedImageUrl = widget.user.imageUrl;

    _loadImageFromPrefs();
  }

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('profile_image');
    if (base64Image != null) {
      try {
        final imageBytes = base64Decode(base64Image);
        final tempFile = await File(
          '${Directory.systemTemp.path}/temp_image.jpg',
        ).writeAsBytes(imageBytes);
        setState(() => _imageFile = tempFile);
      } catch (_) {}
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final base64Image = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', base64Image);
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _confirmRemoveProfileImage() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("هل أنت متأكد؟"),
            content: const Text("هل تريد حذف الصورة الشخصية الحالية؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("نعم، حذف"),
              ),
            ],
          ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('profile_image');
      setState(() {
        _imageFile = null;
        savedImageUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم حذف الصورة الشخصية ✅"),
          backgroundColor: Colors.green,
        ),
      );
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
                leading: const Icon(Icons.camera_alt),
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
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty)
            return 'من فضلك املأ هذا الحقل';
          if (isEmail && !value.contains('@'))
            return 'برجاء إدخال بريد إلكتروني صحيح';
          return null;
        },
        style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.0175),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            size: MediaQuery.of(context).size.height * 0.025,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.015,
            horizontal: MediaQuery.of(context).size.width * 0.04,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.03,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تعديل البيانات"), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.15,
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : (savedImageUrl != null &&
                                  savedImageUrl!.isNotEmpty)
                              ? NetworkImage(
                                "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io"
                                "${savedImageUrl!.startsWith('/') ? '' : '/'}${savedImageUrl!}",
                              )
                              : const NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                              ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: MediaQuery.of(context).size.width * 0.01,
                      child: GestureDetector(
                        onTap: _showImageSourcePicker,
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.04,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.camera_alt,
                            size: MediaQuery.of(context).size.height * 0.02,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_imageFile != null ||
                    (savedImageUrl != null && savedImageUrl!.isNotEmpty))
                  TextButton.icon(
                    onPressed: _confirmRemoveProfileImage,
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    label: const Text(
                      'إزالة الصورة',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                    Expanded(
                      child: _buildFormField(
                        hint: "الدور",
                        icon: Icons.stairs,
                        controller: floorController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0250),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03,
                        ),
                      ),
                    ),
                    onPressed:
                        _isSaving
                            ? null
                            : () async {
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✅ تم حفظ التعديلات بنجاح"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 800),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Profile(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("❌ فشل في حفظ التعديلات"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                    child:
                        _isSaving
                            ? SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.0250,
                              width: MediaQuery.of(context).size.width * 0.05,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              "حفظ التعديلات",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
