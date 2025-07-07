import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/comment.dart';

class CommentInputField extends StatefulWidget {
  final String initialText;
  final Comment? replyingTo;
  final bool isLoading;
  final VoidCallback onCancel;
  final Function(String) onSubmit;

  const CommentInputField({
    Key? key,
    this.initialText = '',
    this.replyingTo,
    required this.isLoading,
    required this.onCancel,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }

  @override
  void didUpdateWidget(covariant CommentInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialText != widget.initialText) {
      _controller.text = widget.initialText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: MyColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط الرد على تعليق
            if (widget.replyingTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: MyColors.whiteSmoke,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.reply, size: 16, color: MyColors.gray),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Replying to ${widget.replyingTo!.userName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: MyColors.gray,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: widget.onCancel,
                    ),
                  ],
                ),
              ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      filled: true,
                      fillColor: MyColors.whiteSmoke,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    enabled: !widget.isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                widget.isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: MyColors.primary),
                        onPressed: _handleSubmit,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
