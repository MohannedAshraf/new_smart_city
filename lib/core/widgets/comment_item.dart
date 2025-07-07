import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatelessWidget {
  final Comment comment;
  final String currentUserId;
  final String postOwnerId;
  final Function(Comment) onEdit;
  final Function(Comment) onDelete;
  final Function(Comment) onReply;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.currentUserId,
    required this.postOwnerId,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
  }) : super(key: key);

  bool get isOwner => comment.userId == currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: comment.parentCommentId == null ? Colors.white : MyColors.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: comment.userAvatarUrl != null && comment.userAvatarUrl!.isNotEmpty
                      ? NetworkImage(comment.userAvatarUrl!)
                      : null,
                  child: (comment.userAvatarUrl == null || comment.userAvatarUrl!.isEmpty)
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        timeago.format(comment.createdAt),
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (isOwner)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    onSelected: (value) {
                      if (value == 'edit') onEdit(comment);
                      else if (value == 'delete') onDelete(comment);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => onReply(comment),
              child: const Text(
                'Reply',
                style: TextStyle(color: MyColors.primary, fontWeight: FontWeight.w500),
              ),
            ),
            if (comment.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Column(
                  children: comment.replies
                      .map((reply) => CommentItem(
                            comment: reply,
                            currentUserId: currentUserId,
                            postOwnerId: postOwnerId,
                            onEdit: onEdit,
                            onDelete: onDelete,
                            onReply: onReply,
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
