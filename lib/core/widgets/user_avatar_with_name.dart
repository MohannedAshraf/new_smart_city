// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citio/models/profile_model.dart';

class UserAvatarWithName extends StatelessWidget {
  final ProfileModel? user;
  final double radius;
  final TextStyle? nameStyle;

  const UserAvatarWithName({
    super.key,
    required this.user,
    this.radius = 22,
    this.nameStyle,
  });

  @override
  Widget build(BuildContext context) {
    final String name =
        user?.fullName?.trim().isNotEmpty == true
            ? user!.fullName!.trim()
            : "مستخدم";

    final String? imageUrl = user?.imageUrl;
    final bool hasImage = imageUrl != null && imageUrl.trim().isNotEmpty;
    final String avatarUrl =
        hasImage
            ? "https://central-user-management.agreeabledune-30ad0cb8.uaenorth.azurecontainerapps.io"
                "${imageUrl.startsWith('/') ? '' : '/'}${imageUrl.trim()}"
            : 'https://cdn-icons-png.flaticon.com/512/13434/13434972.png';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: radius.r,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            name,
            style:
                nameStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
