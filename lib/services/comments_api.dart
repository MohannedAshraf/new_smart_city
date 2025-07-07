import 'dart:convert';
import 'package:citio/core/utils/comment_tree_builder.dart';
import 'package:citio/services/get_user_service.dart';
import 'package:http/http.dart' as http;
import 'package:citio/models/comment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsApi {
  static const String baseCommentsUrl = 'https://graduation.amiralsayed.me/api/comments';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Comment>> fetchCommentsByPostId(String postId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized: No token');

    final url = Uri.parse('$baseCommentsUrl/post/$postId');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Comment> comments = data.map((e) => Comment.fromJson(e)).toList();

    await Future.wait(comments.map((comment) async {
  final userInfo = await UserApi.getUserInfo(comment.userId);
  comment.userName = userInfo['userName'] ?? 'Unknown';
  comment.userAvatarUrl = userInfo['avatarUrl'];
}));


      return buildCommentTree(comments);
    }

    // ✅ Handle "No comments found" as empty list
    else if (response.statusCode == 404) {
      final decoded = json.decode(response.body);
      if (decoded is Map && decoded['message'] == 'No comments found') {
        return [];
      }
    }

    throw Exception('Failed to load comments: ${response.statusCode}');
  }

  static Future<Comment> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized: No token');

    final url = Uri.parse('$baseCommentsUrl/post/$postId');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'content': content,
        'parentCommentId': parentCommentId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Comment.fromJson(data['comment']);
    } else {
      throw Exception('Failed to create comment: ${response.body}');
    }
  }

  static Future<Comment> updateComment({
    required String commentId,
    required String content,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized: No token');

    final url = Uri.parse('$baseCommentsUrl/$commentId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'content': content}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Comment.fromJson(data['comment']);
    } else {
      throw Exception('Failed to update comment: ${response.body}');
    }
  }

  static Future<void> deleteComment(String commentId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Unauthorized: No token');

    final url = Uri.parse('$baseCommentsUrl/$commentId');

    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment: ${response.body}');
    }
  }
}
