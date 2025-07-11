import 'package:flutter/material.dart';
import '../models/comment.dart';
import '../services/comments_api.dart';
import '../core/widgets/comment_item.dart';
import '../core/widgets/comment_input_field.dart';
import '../core/utils/project_strings.dart';

class CommentsPage extends StatefulWidget {
  final String postId;
  final String currentUserId;
  final String postOwnerId;

  const CommentsPage({
    Key? key,
    required this.postId,
    required this.currentUserId,
    required this.postOwnerId,
  }) : super(key: key);

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late Future<List<Comment>> _commentsFuture;
  List<Comment> _comments = [];
  bool _isLoading = false;
  Comment? _editingComment;
  Comment? _replyingToComment;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    setState(() {
      _commentsFuture = CommentsApi.fetchCommentsByPostId(widget.postId);
    });
    _commentsFuture.then((value) {
      setState(() {
        _comments = value;
      });
    });
  }

  Future<void> _addOrUpdateComment(String content) async {
    setState(() => _isLoading = true);

    try {
      if (_editingComment != null) {
        await CommentsApi.updateComment(
          commentId: _editingComment!.id,
          content: content,
        );
      } else {
        await CommentsApi.createComment(
          postId: widget.postId,
          content: content,
          parentCommentId: _replyingToComment?.id,
        );
      }
      _editingComment = null;
      _replyingToComment = null;
      _loadComments();
    } catch (e) {
      print('Error adding/updating comment: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    setState(() => _isLoading = true);
    try {
      await CommentsApi.deleteComment(comment.id);
      _loadComments();
    } catch (e) {
      print('Error deleting comment: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.commentsTitle)),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _comments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (_comments.isEmpty) {
                  return const Center(child: Text(AppStrings.noCommentsYet));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _comments.length,
                  itemBuilder: (context, index) {
                    final comment = _comments[index];
                    return CommentItem(
                      comment: comment,
                      currentUserId: widget.currentUserId,
                      postOwnerId: widget.postOwnerId,
                      onEdit: (comment) {
                        setState(() {
                          _editingComment = comment;
                          _replyingToComment = null;
                        });
                      },
                      onDelete: (comment) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text(AppStrings.confirmDeleteTitle),
                            content: const Text(AppStrings.confirmDeleteMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text(AppStrings.cancel),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text(AppStrings.delete),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await _deleteComment(comment);
                        }
                      },
                      onReply: (comment) {
                        setState(() {
                          _replyingToComment = comment;
                          _editingComment = null;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          CommentInputField(
            key: ValueKey(_editingComment?.id ?? 'new'),
            initialText: _editingComment?.content ?? '',
            replyingTo: _replyingToComment,
            onCancel: () {
              setState(() {
                _editingComment = null;
                _replyingToComment = null;
              });
            },
            onSubmit: (text) {
              if (text.trim().isEmpty) return;
              _addOrUpdateComment(text.trim());
            },
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
