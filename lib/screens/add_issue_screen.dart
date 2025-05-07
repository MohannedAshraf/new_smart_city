// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:citio/core/widgets/emergency_data.dart';
import 'package:citio/helper/api_add_issue.dart';
import 'package:citio/models/add_issue_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _sendComplaint() async {
    final description = _controller.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("من فضلك اكتب وصف الشكوى")));
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم إرسال الشكوى بنجاح")));
        setState(() {
          _controller.clear();
          _selectedImage = null;
        });
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
        title: const Text(
          "شكوي  جديده ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade100,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_selectedImage != null)
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _removeImage,
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'اكتب الشكوى هنا...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image, color: Colors.blue),
                    ),
                    _isLoading
                        ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : IconButton(
                          onPressed: _sendComplaint,
                          icon: const Icon(Icons.send, color: Colors.blue),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
