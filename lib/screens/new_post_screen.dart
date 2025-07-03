// lib/screens/new_post_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/user_avatar_with_name.dart';
import 'package:citio/helper/api_profile.dart';
import 'package:citio/models/profile_model.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final int _maxLength = 1000;
  final int _minLength = 3;
  List<XFile> _images = [];

  ProfileModel? user;
  bool isLoadingProfile = true;

  bool get isPublishEnabled => validatePost();

  bool validatePost() {
    final captionLen = _captionController.text.trim().length;
    final imagesCount = _images.length;

    if (captionLen < _minLength || captionLen > _maxLength) return false;
    if (imagesCount < 1 || imagesCount > 5) return false;

    return true;
  }

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 50.h),
        backgroundColor: Colors.orange.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.white),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'فهمت',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _onAddImageTap() {
    if (_images.length >= 5) {
      _showSnackBarMessage("يمكنك إضافة 5 صور فقط كحد أقصى");
    } else {
      _showImageSourceOptions();
    }
  }

  Future<void> _showImageSourceOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("التقاط صورة بالكاميرا"),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (picked != null) {
                    if (_images.length + 1 > 5) {
                      _showSnackBarMessage("يمكنك إضافة 5 صور فقط كحد أقصى");
                      return;
                    }
                    setState(() => _images.add(picked));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("اختيار من المعرض"),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickMultiImage(imageQuality: 85);
                  if (picked.isNotEmpty) {
                    if (_images.length + picked.length > 5) {
                      _showSnackBarMessage("يمكنك إضافة 5 صور فقط كحد أقصى");
                      return;
                    }
                    setState(() => _images.addAll(picked));
                  }
                },
              ),
            ],
          ),
    );
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _publishPost() {
    if (!validatePost()) {
      if (_captionController.text.trim().length < _minLength) {
        _showSnackBarMessage(
          "عدد حروف المنشور غير كافيه! يجب أن يكون 3 حروف على الأقل",
        );
        return;
      }
      if (_captionController.text.trim().length > _maxLength) {
        _showSnackBarMessage("نص المنشور لا يمكن أن يتجاوز 1000 حرف");
        return;
      }
      if (_images.length < 1) {
        _showSnackBarMessage("يجب إضافة صورة واحدة على الأقل");
        return;
      }
      if (_images.length > 5) {
        _showSnackBarMessage("يمكنك إضافة 5 صور فقط كحد أقصى");
        return;
      }
    }

    // هنا تكتب كود تنفيذ النشر (API)
    print('Caption: ${_captionController.text}');
    print('Images: ${_images.length}');
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final profile = await ApiProfileHelper.fetchProfile();
      setState(() {
        user = profile;
        isLoadingProfile = false;
      });
    } catch (e) {
      print("\u26a0\ufe0f Failed to load profile: $e");
      setState(() => isLoadingProfile = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        title: Text('إضافة منشور', style: TextStyle(color: MyColors.black)),
        backgroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        centerTitle: true,
        leading: BackButton(color: MyColors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoadingProfile
                ? const Center(child: CircularProgressIndicator())
                : UserAvatarWithName(user: user!),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _captionController,
                    maxLength: _maxLength,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: "فينا تفكر ....",
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                  if (_images.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children:
                          _images.asMap().entries.map((entry) {
                            final index = entry.key;
                            final image = entry.value;
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(image.path),
                                    width: 80.w,
                                    height: 80.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(index),
                                    child: CircleAvatar(
                                      radius: 10.r,
                                      backgroundColor: Colors.black.withOpacity(
                                        0.6,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                    SizedBox(height: 10.h),
                  ],
                  SizedBox(height: 6.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_captionController.text.length}/$_maxLength',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: _onAddImageTap,
              child: DottedBorderContainer(hasImage: _images.isNotEmpty),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _publishPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPublishEnabled
                          ? const Color.fromARGB(255, 27, 117, 9)
                          : Colors.grey[300],
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'نشر',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: isPublishEnabled ? Colors.white : Colors.grey[700],
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

class DottedBorderContainer extends StatelessWidget {
  final bool hasImage;
  const DottedBorderContainer({super.key, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey[600]),
            const SizedBox(height: 4),
            Text(
              hasImage ? "إضافة صورة أخرى" : "إضافة صورة",
              style: TextStyle(color: Colors.grey[700]),
            ),
            Text(
              "اضغط لاختيار صورة",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
