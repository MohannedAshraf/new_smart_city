import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
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
        return AppStrings.justNow;
      } else if (difference.inMinutes < 60) {
        return AppStrings.minutesAgo.replaceAll(
          '{X}',
          '${difference.inMinutes}',
        );
      } else if (difference.inHours < 24) {
        return AppStrings.hoursAgo.replaceAll('{X}', '${difference.inHours}');
      } else if (difference.inDays < 7) {
        return AppStrings.daysAgo.replaceAll('{X}', '${difference.inDays}');
      } else {
        final weeks = (difference.inDays / 7).floor();
        return AppStrings.weeksAgo.replaceAll('{X}', '$weeks');
      }
    } catch (e) {
      return AppStrings.fallbackTime;
    }
  }

  Widget buildTrailingWidget(BuildContext context) {
    final double iconSize = MediaQuery.of(context).size.width * 0.05;
    final double fontSize = MediaQuery.of(context).size.width * 0.032;

    switch (type) {
      case 'inprogress':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.hourglass_top, size: iconSize, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              AppStrings.reviewStatus,
              style: TextStyle(fontSize: fontSize, color: Colors.orange),
            ),
          ],
        );
      case 'active':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              Icons.pending_actions,
              size: iconSize,
              color: MyColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              AppStrings.pendingStatus,
              style: TextStyle(fontSize: fontSize, color: MyColors.primary),
            ),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.01,
      ),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: screenHeight * 0.20,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        issue.image != null
                            ? Image.network(
                              _baseUrl + issue.image!,
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size: screenWidth * 0.1,
                                  ),
                            )
                            : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                              width: screenWidth * 0.2,
                              height: screenWidth * 0.2,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Icon(
                                    Icons.broken_image,
                                    size: screenWidth * 0.1,
                                  ),
                            ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize: screenWidth * 0.034,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Text(
                          (type == 'inprogress')
                              ? AppStrings.underReview
                              : (type == 'active')
                              ? getTimeAgo(issue.date)
                              : (issue.date.isNotEmpty ? issue.date : ''),
                          style: TextStyle(
                            fontSize: screenWidth * 0.032,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
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
