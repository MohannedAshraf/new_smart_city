// تم تعديل الكود ليتوافق مع تصميم الصورة المرفقة
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:city/core/widgets/emergency_data.dart';
import 'package:city/helper/api_add_issue.dart';
import 'package:city/models/add_issue_model.dart';

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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.blue),
                title: const Text('الكاميرا'),
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
                leading: const Icon(Icons.photo, color: Colors.green),
                title: const Text('اختيار من المعرض'),
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

  void _sendComplaint() async {
    final description = _controller.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("من فضلك اكتب وصف الشكوى")));
      return;
    }

    final status = await Permission.location.status;
    if (!status.isGranted) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text("صلاحية الموقع مطلوبة"),
              content: const Text(
                "يجب السماح للتطبيق بالوصول إلى الموقع لإرسال الشكوى.",
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final newStatus = await Permission.location.request();
                    if (newStatus.isGranted) _sendComplaint();
                  },
                  child: const Text("سماح بالموقع"),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
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
            content: const Text("تم إرسال الشكوى بنجاح "),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'مشاركة',
              onPressed: () {
                final shareText =
                    "لقد قمت بتقديم شكوى في تطبيق المدينة: ${_controller.text.trim()}";
                Share.share(shareText);
              },
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("فشل في إرسال الشكوى")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("حدث خطأ أثناء الإرسال: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(),
        title: const Text("شكوي جديدة "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: screenWidth,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
  controller: _controller,
  maxLines: 5,
  maxLength: 500,
  onChanged: (_) => setState(() {}), // 👈 مهم لتحديث العداد
  decoration: const InputDecoration(
    hintText: "وصف المشكلة..؟",
    border: InputBorder.none,
    counterText: "",
  ),
),

// 👇 عداد الحروف


const SizedBox(height: 10),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    // 👇 زر اختيار الصورة بلون أسود
    TextButton.icon(
      onPressed: _pickImage,
      icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
      label: const Text(
        "إضافة صورة",
        style: TextStyle(color: Colors.black),
      ),
    ),

    // 👇 زر الإرسال بلون أزرق والنص باللون الأبيض
    ElevatedButton.icon(
      onPressed: _isLoading ? null : _sendComplaint,
      icon: const Icon(Icons.send, color: Colors.white),
      label: const Text(
        "إرسال",
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
  ],
),
Align(
  alignment: Alignment.centerRight,
  child: Text(
    '${_controller.text.length}/500',
    style: const TextStyle(fontSize: 12, color: Colors.grey),
  ),
),
],
                
              ),
            ),
            const Spacer(),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
