// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_post_service.dart';
import 'package:citio/models/socialmedia_user_minimal.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  final SocialmediaUserMinimal user;
  const NewPostScreen({super.key, required this.user});

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final int _maxLength = 1000;
  final int _minLength = 3;
  final List<XFile> _images = [];

  late final SocialmediaUserMinimal myUser;
  bool isLoadingUser = true;
  bool isSubmitting = false;

  bool get isPublishEnabled => validatePost();

  bool validatePost() {
    final captionLen = _captionController.text.trim().length;
    final imagesCount = _images.length;
    return captionLen >= _minLength &&
        captionLen <= _maxLength &&
        imagesCount <= 5;
  }

  void _showSnackBarMessage(String message) {
    Color backgroundColor;

    if (message.contains("✅")) {
      backgroundColor = Colors.green;
    } else if (message.contains("❌")) {
      backgroundColor = Colors.red;
    } else {
      backgroundColor = Colors.orange;
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(
          width * 0.05,
          height * 0.01,
          width * 0.05,
          height * 0.03,
        ),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              message.contains("✅")
                  ? Icons.check_circle_outline
                  : message.contains("❌")
                  ? Icons.error_outline
                  : Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Text(
                message.replaceAll("✅", "").replaceAll("❌", "").trim(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: AppStrings.confirm,
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _onAddImageTap() {
    if (_images.length >= 5) {
      _showSnackBarMessage(AppStrings.maxImagesWarning);
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
                title: const Text(AppStrings.camera),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (picked != null && _images.length < 5) {
                    setState(() => _images.add(picked));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(AppStrings.gallery),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickMultiImage(imageQuality: 85);
                  if (picked.isNotEmpty &&
                      _images.length + picked.length <= 5) {
                    setState(() => _images.addAll(picked));
                  } else {
                    _showSnackBarMessage(AppStrings.maxImagesWarning);
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

  void _publishPost() async {
    if (!validatePost()) {
      if (_captionController.text.trim().length < _minLength) {
        _showSnackBarMessage(AppStrings.captionTooShort);
        return;
      }
      if (_captionController.text.trim().length > _maxLength) {
        _showSnackBarMessage(AppStrings.captionTooLong);
        return;
      }
    }

    try {
      setState(() => isSubmitting = true);
      final errorMsg = await ApiPostHelper.createNewPost(
        postCaption: _captionController.text.trim(),
        mediaFiles: _images,
      );
      if (errorMsg == null) {
        _showSnackBarMessage(AppStrings.postSuccess);
        _captionController.clear();
        setState(() => _images.clear());
      } else {
        _showSnackBarMessage(AppStrings.postFail);
      }
    } catch (_) {
      _showSnackBarMessage(AppStrings.unexpectedError);
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    myUser = widget.user;
    isLoadingUser = false;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        title: const Text(
          AppStrings.addPost,
          style: TextStyle(color: MyColors.black),
        ),
        backgroundColor: MyColors.white,
        centerTitle: true,
        leading: const BackButton(color: MyColors.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.04,
          vertical: height * 0.012,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoadingUser)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  CircleAvatar(
                    radius: width * 0.06,
                    backgroundImage: NetworkImage(
                      myUser.avatarUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Text(
                    myUser.localUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ],
              ),
            SizedBox(height: height * 0.02),
            Container(
              padding: EdgeInsets.all(width * 0.03),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _captionController,
                    maxLength: _maxLength,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: AppStrings.captionHint,
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    enabled: !isSubmitting,
                  ),
                  if (_images.isNotEmpty) ...[
                    SizedBox(height: height * 0.01),
                    Wrap(
                      spacing: width * 0.02,
                      runSpacing: height * 0.01,
                      children:
                          _images.asMap().entries.map((entry) {
                            final index = entry.key;
                            final image = entry.value;
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(image.path),
                                    width: width * 0.2,
                                    height: width * 0.2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap:
                                        isSubmitting
                                            ? null
                                            : () => _removeImage(index),
                                    child: CircleAvatar(
                                      radius: width * 0.03,
                                      backgroundColor: Colors.black.withOpacity(
                                        0.6,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                    SizedBox(height: height * 0.01),
                  ],
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_captionController.text.length}/$_maxLength',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.02),
            GestureDetector(
              onTap: isSubmitting ? null : _onAddImageTap,
              child: DottedBorderContainer(hasImage: _images.isNotEmpty),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.012,
          ),
          child: SizedBox(
            width: double.infinity,
            height: height * 0.07,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _publishPost,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isPublishEnabled ? MyColors.primary : Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  isSubmitting
                      ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                      : Text(
                        AppStrings.publish,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color:
                              isPublishEnabled
                                  ? Colors.white
                                  : Colors.grey[700],
                        ),
                      ),
            ),
          ),
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
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: width * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 30, color: Colors.grey[600]),
            const SizedBox(height: 4),
            Text(
              hasImage ? AppStrings.addAnotherImage : AppStrings.addImage,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const Text(
              AppStrings.tapToPickImage,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
