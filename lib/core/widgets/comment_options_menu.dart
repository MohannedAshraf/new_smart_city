import 'package:flutter/material.dart';

class CommentOptionsMenu extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentOptionsMenu({
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: Colors.black),
      onSelected: (value) {
        if (value == 'edit' && onEdit != null) {
          onEdit!();
        } else if (value == 'delete' && onDelete != null) {
          onDelete!();
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<String>>[];
        if (onEdit != null) {
          items.add(const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ));
        }
        if (onDelete != null) {
          items.add(const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ));
        }
        return items;
      },
    );
  }
}
