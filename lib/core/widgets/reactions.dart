import 'package:citio/core/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _cityWebsiteUrl = Uri.parse(
  'https://graduation-project-2025.vercel.app/auth',
);

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
      onPressed:
          () =>
              showDialog(context: context, builder: (_) => const PopUpDialog()),
      icon: reactionIcon,
      color: reactionIconColor,
    );
  }
}

class PopUpDialog extends StatelessWidget {
  const PopUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.info_outline, color: MyColors.primary),
          SizedBox(width: screenWidth * 0.02),
          Expanded(
            child: Text(
              AppStrings.dialogTitle,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.dialogBody,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: screenWidth * 0.05),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.035,
                    ),
                  ),
                  child: Text(
                    AppStrings.cancel,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      () => launchUrl(
                        _cityWebsiteUrl,
                        mode: LaunchMode.externalApplication,
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.035,
                    ),
                  ),
                  child: Text(
                    AppStrings.goToWebsite,
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
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
