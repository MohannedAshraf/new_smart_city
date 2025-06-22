import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String title;
  final int count;

  const TabItem({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, overflow: TextOverflow.ellipsis),
          count > 0
              ? Container(
                margin: const EdgeInsets.only(left: 4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    count > 9 ? "9+" : count.toString(),
                    style: const TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ),
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
