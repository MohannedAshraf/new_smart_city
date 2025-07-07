class Comment {
  final String id;
  final String postId;
  final String userId;
  String userName;
  String? userAvatarUrl;
  final String content;
  final String? parentCommentId;
  List<Comment> replies;
  final List<String>? repliesIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.content,
    this.parentCommentId,
    this.replies = const [],
    this.repliesIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      postId: json['postId'],
      userId: json['userId'],
      userName: json['userName'] ?? 'Unknown',
      userAvatarUrl: json['userAvatarUrl'],
      content: json['content'],
      parentCommentId: json['parentCommentId'],
      repliesIds:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
      replies: [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}