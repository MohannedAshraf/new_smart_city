import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _cityWebsiteUrl = Uri.parse('https://graduation-project-2025.vercel.app/auth');

class Reactions extends StatelessWidget {
  const Reactions({
    required this.reactionIcon,
    required this.reactionHoverColor,
    this.reactionIconColor = MyColors.black,
    super.key,
  });

  final Icon reactionIcon;
  final Color reactionIconColor;
  final Color reactionHoverColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      hoverColor: reactionHoverColor,
      onPressed: () => showDialog(
        context: context,
        builder: (_) => const PopUpDialog(),
      ),
      icon: reactionIcon,
      color: reactionIconColor,
    );
  }
}

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: MyColors.primary),
          SizedBox(width: 8.w),
          Text(
            'يجب الانتقال لمجتمع المدينة',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'لتتمكن من تنفيذ هذا التفاعل، يُرجى التوجه إلى الموقع الرسمي للمدينة وتسجيل الدخول من هناك.',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => launchUrl(_cityWebsiteUrl, mode: LaunchMode.externalApplication),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    'الانتقال للموقع',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
