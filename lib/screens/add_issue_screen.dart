// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:citio/core/widgets/emergency_data.dart';
import 'package:citio/helper/api_add_issue.dart';
import 'package:citio/models/add_issue_model.dart';
import 'package:citio/screens/first_issue_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQuery.of(context).size.width * 0.04),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.blue,
                  size: MediaQuery.of(context).size.height * 0.02750,
                ),
                title: Text(
                  'الكاميرا',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.0175,
                  ),
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
                leading: Icon(
                  Icons.photo,
                  color: Colors.green,
                  size: MediaQuery.of(context).size.height * 0.02750,
                ),
                title: Text(
                  'اختيار من المعرض',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.0175,
                  ),
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
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
              child: Image.file(imageFile, fit: BoxFit.contain),
            ),
          ),
    );
  }

  void _sendComplaint() async {
    final description = _controller.text.trim();
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "من فضلك اكتب وصف الشكوى",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0175,
            ),
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
                "صلاحية الموقع مطلوبة",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              content: Text(
                "يجب السماح للتطبيق بالوصول إلى الموقع لإرسال الشكوى.",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final newStatus = await Permission.location.request();
                    if (newStatus.isGranted) _sendComplaint();
                  },
                  child: Text(
                    "سماح بالموقع",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0175,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إلغاء",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.0175,
                    ),
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
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: MediaQuery.of(context).size.height * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.03,
              ),
            ),
            backgroundColor: Colors.green.shade600,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "✅ تم إرسال الشكوى بنجاح، شكرًا لمساهمتك!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.01625,
                    ),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.0075,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.share,
                    size: MediaQuery.of(context).size.height * 0.02,
                    color: Colors.white,
                  ),
                  label: Text(
                    "مشاركة",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.height * 0.01625,
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
              "فشل في إرسال الشكوى",
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.0175,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "🚨 حدثت مشكلة أثناء إرسال الشكوى. الرجاء المحاولة لاحقًا.",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.0175,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: MediaQuery.of(context).size.height * 0.015,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.03,
            ),
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
          "شكوى جديدة",
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02250,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.04,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: MediaQuery.of(context).size.width * 0.02,
                    offset: Offset(
                      0,
                      MediaQuery.of(context).size.height * 0.0025,
                    ),
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
                      hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.0175,
                      ),
                      border: InputBorder.none,
                      counterText: "",
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
                  if (_selectedImage != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () => _previewImage(_selectedImage!),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.03,
                                ),
                                child: Image.file(
                                  _selectedImage!,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.005,
                              right: MediaQuery.of(context).size.width * 0.01,
                              child: GestureDetector(
                                onTap: _removeImage,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(184, 255, 2, 2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width * 0.01,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size:
                                          MediaQuery.of(context).size.height *
                                          0.02,
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
                          size: MediaQuery.of(context).size.height * 0.025,
                          color: Colors.black,
                        ),
                        label: Text(
                          "إضافة صورة",
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _sendComplaint,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height * 0.02250,
                        ),
                        label: Text(
                          "إرسال",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.width * 0.06,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_controller.text.length}/500',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.015,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            TextButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const IssueScreen()),
                );
              },
              icon: Icon(
                Icons.list_alt,
                size: MediaQuery.of(context).size.height * 0.025,
                color: Colors.blueAccent,
              ),
              label: Text(
                'عرض الشكاوى السابقة',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.0175,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(),
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.02,
                ),
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
