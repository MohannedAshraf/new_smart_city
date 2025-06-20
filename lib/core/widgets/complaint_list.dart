import 'package:flutter/material.dart';
import 'package:city/core/utils/mycolors.dart';
import 'package:city/models/issue.dart';

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class ComplaintList extends StatelessWidget {
  final List<Values> issues;
  final String type; // 👈 'resolved', 'active', 'inprogress'

  const ComplaintList({super.key, required this.issues, required this.type});

  Widget buildTrailingWidget() {
   switch (type) {
  case 'inprogress':
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
   Icon(Icons.hourglass_top, size: 20, color: Colors.orange),        SizedBox(height: 4),
        Text('قيد المراجعة', style: TextStyle(fontSize: 13, color: Colors.orange)),
      ],
    );

  case 'active':
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
      Icon(Icons.pending_actions, size: 20, color: Colors.blue),
        SizedBox(height: 4),
      Text(' قيد الانتظار', style: TextStyle(fontSize: 13, color: Colors.blue)),
      ],
    );

  default:
    return const SizedBox(); // مفيش حاجة إضافية
}
 }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: 140,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: issue.image != null
                        ? Image.network(
                            _baseUrl + issue.image!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 40),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 32),
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          issue.description ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                      issue.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                     ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  buildTrailingWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
