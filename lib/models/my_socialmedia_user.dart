import 'package:citio/core/utils/variables.dart';

class MySocialmediaUser {
  final String id;
  final String centralUsrId;
  final String role;
  final String userName;
  final String localUserName;
  final String email;
  final String? avatarUrl;
  final String? coverUrl;
  final String? bio;
  final List<String> friends;
  final List<String> posts;
  final List<String> savedPosts;
  final List<String> sharedPosts;
  final String createdAt;
  final String updatedAt;

  MySocialmediaUser({
    required this.id,
    required this.centralUsrId,
    required this.role,
    required this.userName,
    required this.localUserName,
    required this.email,
    this.avatarUrl,
    this.coverUrl,
    this.bio,
    required this.friends,
    required this.posts,
    required this.savedPosts,
    required this.sharedPosts,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MySocialmediaUser.fromJson(Map<String, dynamic> json) {
    return MySocialmediaUser(
      id: json['_id'] ?? '',
      centralUsrId: json['centralUsrId'] ?? '',
      role: json['role'] ?? '',
      userName: json['userName'] ?? '',
      localUserName: json['localUserName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] != null
          ? Urls.socialmediaBaseUrl + json['avatarUrl']
          : null,
      coverUrl: json['coverUrl'] != null
          ? Urls.socialmediaBaseUrl + json['coverUrl']
          : null,
      bio: json['bio'],
      friends: List<String>.from(json['friends'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
      savedPosts: List<String>.from(json['savedPosts'] ?? []),
      sharedPosts: List<String>.from(json['sharedPosts'] ?? []),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
