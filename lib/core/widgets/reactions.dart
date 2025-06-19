import 'package:citio/core/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://x.com/home');

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
          () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => const PopUpDialog(),
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
      title: const Text('سيتم تحويلك خارج  citio'),
      content: const Text('هل أنت متأكد بأنك ترغب بالرحيل'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('الغاء'),
        ),
        TextButton(
          onPressed: () {
            launchUrl(_url, mode: LaunchMode.inAppWebView);
          },
          child: const Text('نعم'),
        ),
      ],
    );
  }
}
