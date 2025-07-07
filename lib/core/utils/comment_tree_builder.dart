import 'package:citio/models/comment.dart';

List<Comment> buildCommentTree(List<Comment> comments) {
  final map = { for (var c in comments) c.id : c };

  // تفرغ الـ replies الأول
  for (var comment in comments) {
    comment.replies = [];
  }

  for (var comment in comments) {
    if (comment.repliesIds != null && comment.repliesIds!.isNotEmpty) {
      for (var replyId in comment.repliesIds!) {
        final replyComment = map[replyId];
        if (replyComment != null) {
          comment.replies.add(replyComment);
        }
      }
    }
  }

  return comments.where((c) => c.parentCommentId == null).toList();
}
