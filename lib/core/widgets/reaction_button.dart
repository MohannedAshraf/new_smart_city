import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:citio/core/widgets/reaction_icon_mapper.dart';
import 'package:citio/core/widgets/reaction_dialog.dart';
import 'package:citio/services/socialmedia_reactions_api.dart';
import 'package:citio/core/utils/variables.dart';

class ReactionButton extends StatefulWidget {
  final String postId;
  final String? currentUserReaction;
  final int totalCount;
  final Function(String newReaction, int newTotal)? onReacted;

  const ReactionButton({
    super.key,
    required this.postId,
    this.currentUserReaction,
    required this.totalCount,
    this.onReacted,
  });

  @override
  State<ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<ReactionButton> {
  late String? _userReaction;
  late int _totalCount;

  @override
  void initState() {
    super.initState();
    _userReaction = widget.currentUserReaction;
    _totalCount = widget.totalCount;
  }

  Future<void> _sendReaction(String reactionType) async {
    final success = await SocialMediaReactionsApi.sendReaction(
      postId: widget.postId,
      reactionType: reactionType,
    );

    if (success != null) {
      setState(() {
        _userReaction = reactionType.isEmpty ? null : reactionType;
        _totalCount = success.total ?? _totalCount;
      });
      widget.onReacted?.call(_userReaction ?? '', _totalCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_userReaction != null) {
          // حذف الريأكت الحالي
          await _sendReaction('');
        } else {
          // إضافة لايك
          await _sendReaction('like');
        }
      },
      onLongPress: () async {
        final selected = await showDialog<String>(
          context: context,
          builder: (_) => const ReactionDialog(),
        );

        if (selected != null) {
          await _sendReaction(selected);
        }
      },
      child: Row(
        children: [
          ReactionIconMapper.getReactionIcon(_userReaction, size: 24),
          SizedBox(width: 4.w),
          Text(
            '$_totalCount',
            style: TextStyle(color: MyColors.gray, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}
