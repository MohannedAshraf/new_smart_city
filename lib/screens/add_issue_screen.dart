import 'dart:io';
import 'package:citio/core/widgets/emergency_data.dart';
import 'package:citio/helper/api_add_issue.dart';
import 'package:citio/models/add_issue_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅

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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)), // ✅
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue, size: 22.sp),
                title: Text('الكاميرا', style: TextStyle(fontSize: 14.sp)),
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
                leading: Icon(Icons.photo, color: Colors.green, size: 22.sp),
                title: Text('اختيار من المعرض', style: TextStyle(fontSize: 14.sp)),
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
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.file(imageFile, fit: BoxFit.contain),
        ),
      ),
    );
  }

  void _sendComplaint() async {
    final description = _controller.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("من فضلك اكتب وصف الشكوى", style: TextStyle(fontSize: 14.sp))),
      );
      return;
    }

    final status = await Permission.location.status;
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("صلاحية الموقع مطلوبة", style: TextStyle(fontSize: 16.sp)),
          content: Text(
            "يجب السماح للتطبيق بالوصول إلى الموقع لإرسال الشكوى.",
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final newStatus = await Permission.location.request();
                if (newStatus.isGranted) _sendComplaint();
              },
              child: Text("سماح بالموقع", style: TextStyle(fontSize: 14.sp)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء", style: TextStyle(fontSize: 14.sp)),
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
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: Colors.green.shade600,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "✅ تم إرسال الشكوى بنجاح، شكرًا لمساهمتك!",
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    final shareText =
                        "لقد قمت بتقديم شكوى في تطبيق المدينة: $description";
                    Share.share(shareText);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green.shade800,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  icon: Icon(Icons.share, size: 16.sp, color: Colors.white),
                  label: Text("مشاركة", style: TextStyle(color: Colors.white, fontSize: 13.sp)),
                ),
              ],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في إرسال الشكوى", style: TextStyle(fontSize: 14.sp))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "🚨 حدثت مشكلة أثناء إرسال الشكوى. الرجاء المحاولة لاحقًا.",
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
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
        title: Text("شكوى جديدة", style: TextStyle(fontSize: 18.sp)),
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
                      hintText: "وصف المشكلة..؟",
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
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 16.sp),
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
                        icon: Icon(Icons.camera_alt_outlined, size: 20.sp, color: Colors.black),
                        label: Text("إضافة صورة", style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _sendComplaint,
                        icon: Icon(Icons.send, color: Colors.white, size: 18.sp),
                        label: Text("إرسال", style: TextStyle(color: Colors.white, fontSize: 14.sp)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
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
