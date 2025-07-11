import 'package:cached_network_image/cached_network_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/models/comment.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentItem extends StatefulWidget {
  final Comment comment;
  final String currentUserId;
  final String postOwnerId;
  final Function(Comment) onEdit;
  final Function(Comment) onDelete;
  final Function(Comment) onReply;
  final Function(Comment parent, String content) onReplySubmit;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.currentUserId,
    required this.postOwnerId,
    required this.onEdit,
    required this.onDelete,
    required this.onReply,
    required this.onReplySubmit,
  }) : super(key: key);

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool showReplies = false;
  bool showReplyField = false;
  final TextEditingController _replyController = TextEditingController();
  bool _isSendingReply = false;

  bool get isOwner => widget.comment.userId == widget.currentUserId;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _submitReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSendingReply = true);
    await widget.onReplySubmit(widget.comment, text);
    setState(() {
      _isSendingReply = false;
      showReplyField = false;
      _replyController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: comment.parentCommentId == null ? Colors.white : MyColors.whiteSmoke,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
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
                      ? CachedNetworkImageProvider(comment.userAvatarUrl!)
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
                      Text(comment.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                      if (value == 'edit') widget.onEdit(comment);
                      if (value == 'delete') widget.onDelete(comment);
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'edit', child: Text(AppStrings.edit)),
                      PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => showReplyField = !showReplyField),
              child: const Text(
                AppStrings.reply,
                style: TextStyle(
                  color: MyColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showReplyField)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AppStrings.replyingTo} ${comment.userName}',
                      style: const TextStyle(fontSize: 12, color: MyColors.gray),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyController,
                            minLines: 1,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: AppStrings.writeAReply,
                              filled: true,
                              fillColor: MyColors.whiteSmoke,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _isSendingReply
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : IconButton(
                                icon: const Icon(Icons.send, color: MyColors.primary),
                                onPressed: _submitReply,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            if (comment.replies.isNotEmpty && !showReplies)
              GestureDetector(
                onTap: () => setState(() => showReplies = true),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 10),
                  child: Text(
                    '${AppStrings.viewReplies} (${comment.replies.length})',
                    style: const TextStyle(color: MyColors.primary, fontSize: 13),
                  ),
                ),
              ),
            if (showReplies)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: ListView.builder(
                  itemCount: comment.replies.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final reply = comment.replies[index];
                    return CommentItem(
                      comment: reply,
                      currentUserId: widget.currentUserId,
                      postOwnerId: widget.postOwnerId,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                      onReply: widget.onReply,
                      onReplySubmit: widget.onReplySubmit,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
