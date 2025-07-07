// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/widgets/emergency_data.dart';
import 'package:citio/helper/api_add_issue.dart';
import 'package:citio/models/add_issue_model.dart';
import 'package:citio/screens/first_issue_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewComplaintCenterPage extends StatefulWidget {
  const NewComplaintCenterPage({super.key});

  @override
  _NewComplaintCenterPageState createState() => _NewComplaintCenterPageState();
}

class _NewComplaintCenterPageState extends State<NewComplaintCenterPage> {
  final TextEditingController _controller = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final mediaQuery = MediaQuery.of(context);
    final double iconSize = mediaQuery.size.width * 0.05; // تقريبًا زي 22.sp
    final double fontSize = mediaQuery.size.width * 0.035; // تقريبًا زي 14.sp

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // ثابت
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: MyColors.primary,
                  size: iconSize,
                ),
                title: Text(
                  'الكاميرا', // تقدر تغيرها إلى AppStrings.cameraText إذا أضفتها
                  style: TextStyle(fontSize: fontSize),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo, color: Colors.green, size: iconSize),
                title: Text(
                  'اختيار من المعرض', // تقدر تغيرها إلى AppStrings.galleryText إذا أضفتها
                  style: TextStyle(fontSize: fontSize),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() => _selectedImage = File(pickedFile.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() => _selectedImage = null);
  }

  void _previewImage(File imageFile) {
    final double radius =
        MediaQuery.of(context).size.width * 0.03; // تقريبًا زي 12.r

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
    );
  }

  void _sendComplaint() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final description = _controller.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.complaintDescriptionEmpty,
            style: TextStyle(fontSize: screenWidth * 0.035),
          ),
        ),
      );
      return;
    }

    final status = await Permission.location.status;
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(
                AppStrings.locationPermissionRequiredTitle,
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              content: Text(
                AppStrings.locationPermissionRequiredBody,
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final newStatus = await Permission.location.request();
                    if (newStatus.isGranted) _sendComplaint();
                  },
                  child: Text(
                    AppStrings.allowLocation,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
              ],
            ),
      );
      return;
    }

    final address = EmergencyFakeData.getRandomAddress();
    final latitude = EmergencyFakeData.getRandomLatitude();
    final longitude = EmergencyFakeData.getRandomLongitude();
    final issueKey = EmergencyFakeData.getRandomIssueCategoryKey();

    setState(() => _isLoading = true);

    try {
      final service = ComplaintApiService();
      ComplaintResponse response = await service.sendComplaint(
        description: description,
        address: address,
        latitude: latitude,
        longitude: longitude,
        issueCategoryKey: issueKey,
        image: _selectedImage,
      );

      if (response.isSuccess) {
        _controller.clear();
        _selectedImage = null;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            backgroundColor: Colors.green.shade600,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    AppStrings.complaintSuccessMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.032,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final shareText =
                        "${AppStrings.shareTextPrefix}$description";
                    Share.share(shareText);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  icon: Icon(
                    Icons.share,
                    size: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                  label: Text(
                    AppStrings.shareComplaint,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.032,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppStrings.complaintFailed,
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppStrings.complaintError,
            style: TextStyle(fontSize: screenWidth * 0.035),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.015,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(),
        title: Text(
          AppStrings.newComplaintTitle,
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    maxLength: 500,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: AppStrings.descriptionHint,
                      hintStyle: TextStyle(fontSize: 14.sp),
                      border: InputBorder.none,
                      counterText: "",
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (_selectedImage != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _previewImage(_selectedImage!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  _selectedImage!,
                                  width: 80.w,
                                  height: 80.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4.h,
                              right: 4.w,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(184, 255, 2, 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.w),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          size: 20.sp,
                          color: Colors.black,
                        ),
                        label: Text(
                          AppStrings.addImage,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _sendComplaint,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                        label: Text(
                          AppStrings.send,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_controller.text.length}/500',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const IssueScreen()),
                );
              },
              icon: Icon(Icons.list_alt, size: 20.sp, color: MyColors.primary),
              label: Text(
                AppStrings.previousComplaints,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: MyColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(8.w),
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
