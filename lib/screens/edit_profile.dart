// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
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

  double wp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.width * percent / 100;

  double hp(BuildContext context, double percent) =>
      MediaQuery.of(context).size.height * percent / 100;

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
            title: const Text(AppStrings.deleteImageConfirmTitle),
            content: const Text(AppStrings.deleteImageConfirmContent),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(AppStrings.delete),
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
          content: Text(AppStrings.imageDeleted),
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
                title: const Text(AppStrings.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(AppStrings.pickFromGallery),
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
      padding: EdgeInsets.symmetric(vertical: hp(context, 1.2)),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty)
            return AppStrings.fillField;
          if (isEmail && !value.contains('@')) return AppStrings.invalidEmail;
          return null;
        },
        style: TextStyle(fontSize: wp(context, 3.5)),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: wp(context, 4.5)),
          contentPadding: EdgeInsets.symmetric(
            vertical: hp(context, 1.5),
            horizontal: wp(context, 4),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(wp(context, 3)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: wp(context, 5)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: hp(context, 3)),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: wp(context, 15),
                      backgroundImage:
                          _imageFile != null
                              ? FileImage(_imageFile!)
                              : (savedImageUrl != null &&
                                  savedImageUrl!.isNotEmpty)
                              ? NetworkImage(
                                Urls.cmsBaseUrl +
                                    (savedImageUrl!.startsWith('/')
                                        ? ''
                                        : '/') +
                                    savedImageUrl!,
                              )
                              : const NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                                  )
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: wp(context, 1),
                      child: GestureDetector(
                        onTap: _showImageSourcePicker,
                        child: CircleAvatar(
                          radius: wp(context, 4),
                          backgroundColor: MyColors.primary,
                          child: Icon(
                            Icons.camera_alt,
                            size: wp(context, 4),
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
                      AppStrings.removeImage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: hp(context, 2)),
                _buildFormField(
                  hint: AppStrings.nameHint,
                  icon: Icons.person,
                  controller: nameController,
                ),
                _buildFormField(
                  hint: AppStrings.phoneHint,
                  icon: Icons.phone,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                ),
                _buildFormField(
                  hint: AppStrings.emailHint,
                  icon: Icons.email,
                  controller: emailController,
                  isEmail: true,
                ),
                _buildFormField(
                  hint: AppStrings.addressHint,
                  icon: Icons.location_on,
                  controller: addressController,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        hint: AppStrings.buildingHint,
                        icon: Icons.apartment,
                        controller: buildingController,
                      ),
                    ),
                    SizedBox(width: wp(context, 2)),
                    Expanded(
                      child: _buildFormField(
                        hint: AppStrings.floorHint,
                        icon: Icons.stairs,
                        controller: floorController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: hp(context, 3)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      padding: EdgeInsets.symmetric(vertical: hp(context, 2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(wp(context, 3)),
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
                                      content: Text(AppStrings.saveSuccess),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  await Future.delayed(
                                    const Duration(milliseconds: 600),
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
                                      content: Text(AppStrings.saveFail),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                    child:
                        _isSaving
                            ? SizedBox(
                              height: hp(context, 3),
                              width: wp(context, 3),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              AppStrings.saveChanges,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: wp(context, 4),
                              ),
                            ),
                  ),
                ),
                SizedBox(height: hp(context, 1.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
