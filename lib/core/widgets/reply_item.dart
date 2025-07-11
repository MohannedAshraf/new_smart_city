// ignore_for_file: use_super_parameters

import 'package:citio/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'comment_options_menu.dart';

class ReplyItem extends StatelessWidget {
  final Comment reply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReplyItem({
    Key? key,
    required this.reply,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  String _formatDate(DateTime date) {
    // صيغة عرض الوقت مثلاً: 24 Feb 2025, 10:00 AM
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200], // لون الخلفية الخاص بالردود
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المستخدم - لو عندك صورة رابطها بدل placeholder
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(reply.userAvatarUrl ?? ''),
            // لو ما فيش صورة، ممكن تحط Icon بديل
            onBackgroundImageError: (_, __) {},
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // اسم المستخدم والوقت
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reply.userName ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _formatDate(reply.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    CommentOptionsMenu(onEdit: onEdit, onDelete: onDelete),
                  ],
                ),
                const SizedBox(height: 6),
                Text(reply.content),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
