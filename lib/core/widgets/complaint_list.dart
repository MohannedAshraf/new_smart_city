import 'package:citio/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class ComplaintList extends StatelessWidget {
  final List<Values> issues;
  final String type;

  const ComplaintList({super.key, required this.issues, required this.type});

  String getTimeAgo(String dateString) {
    try {
      final fixedDateString = dateString.replaceAllMapped(
        RegExp(r'([a-zA-Z]+ \d{1,2}),(\d{4})'),
        (match) => '${match[1]}, ${match[2]}',
      );

      final dateFormat = DateFormat("MMMM d, yyyy h:mm a", "en_US");
      final dateTime = dateFormat.parse(fixedDateString, true);

      final now = DateTime.now();
      final difference = now.difference(dateTime);
      if (difference.inSeconds < 60) {
        return "منذ لحظات";
      } else if (difference.inMinutes < 60) {
        return "منذ ${difference.inMinutes} دقيقة";
      } else if (difference.inHours < 24) {
        return "منذ ${difference.inHours} ساعة";
      } else if (difference.inDays < 7) {
        return "منذ ${difference.inDays} يوم";
      } else {
        final weeks = (difference.inDays / 7).floor();
        return "منذ $weeks أسبوع";
      }
    } catch (e) {
      return "منذ فترة";
    }
  }

  Widget buildTrailingWidget(BuildContext context) {
    switch (type) {
      case 'inprogress':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.hourglass_top,
              size: MediaQuery.of(context).size.height * 0.025,
              color: Colors.orange,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Text(
              'قيد المراجعة',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.01625,
                color: Colors.orange,
              ),
            ),
          ],
        );
      case 'active':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.pending_actions,
              size: MediaQuery.of(context).size.height * 0.025,
              color: Colors.blue,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            Text(
              'قيد الانتظار',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.01625,
                color: Colors.blue,
              ),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.1875,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04,
              ),
            ),
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.02,
                    ),
                    child:
                        issue.image != null
                            ? Image.network(
                              _baseUrl + issue.image!,
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size:
                                        MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                            )
                            : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                              width: MediaQuery.of(context).size.width * 0.2,
                              height: MediaQuery.of(context).size.height * 0.1,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size:
                                        MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                            ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0075,
                        ),
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          (type == 'inprogress')
                              ? 'تحت المراجعة'
                              : (type == 'active')
                              ? getTimeAgo(issue.date)
                              : (issue.date.isNotEmpty ? issue.date : ''),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: buildTrailingWidget(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
