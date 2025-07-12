// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/helper/api_rating_issue.dart';
import 'package:citio/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class RatedComplaintList extends StatelessWidget {
  final List<Values> issues;
  const RatedComplaintList({super.key, required this.issues});

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
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
            ),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
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
                            fontSize: screenWidth * 0.037,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenHeight * 0.006),
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: const Color.fromARGB(255, 0, 3, 5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                                                const Spacer(),

                        SizedBox(height: screenHeight * 0.006),
                        Text(
                          AppStrings.solved,
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: () {
                        final TextEditingController commentController =
                            TextEditingController();
                        double selectedRating = 0;

                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.04,
                                  ),
                                ),
                                backgroundColor: Colors.white,
                                title: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: MyColors.primary,
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Text(
                                      AppStrings.rate,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppStrings.pleaseRate,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.015),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: screenWidth * 0.07,
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.01,
                                      ),
                                      itemBuilder:
                                          (context, _) => Icon(
                                            Icons.star,
                                            color: MyColors.primary,
                                            size: screenWidth * 0.06,
                                          ),
                                      onRatingUpdate: (rating) {
                                        selectedRating = rating;
                                      },
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: AppStrings.writeComment,
                                        hintStyle: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            screenWidth * 0.03,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.all(
                                          screenWidth * 0.03,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.025),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.redAccent,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      screenWidth * 0.03,
                                                    ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.015,
                                              ),
                                            ),
                                            child: Text(
                                              AppStrings.cancel,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.03),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              final comment =
                                                  commentController.text.trim();
                                              if (selectedRating == 0.0) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      AppStrings
                                                          .selectRatingFirst,
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.035,
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                                return;
                                              }

                                              try {
                                                final feedbackService =
                                                    FeedbackApiService();
                                                final response =
                                                    await feedbackService
                                                        .sendFeedback(
                                                          issueReportId:
                                                              issue.id,
                                                          comment: comment,
                                                          rateValue:
                                                              selectedRating
                                                                  .toInt(),
                                                        );

                                                if (response.isSuccess) {
                                                  Navigator.of(context).pop();

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Expanded(
                                                            child: Text(
                                                              AppStrings
                                                                  .complaintSuccessMessage,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton.icon(
                                                            onPressed: () {
                                                              final shareText =
                                                                  "${AppStrings.shareTextPrefix}${issue.description ?? ''}";
                                                              Share.share(
                                                                shareText,
                                                              );
                                                            },
                                                            icon: const Icon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            label: const Text(
                                                              AppStrings
                                                                  .shareComplaint,
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                            style: TextButton.styleFrom(
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                    255,
                                                                    13,
                                                                    109,
                                                                    103,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          MyColors.primary,
                                                      duration: const Duration(
                                                        seconds: 4,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        response
                                                                .message
                                                                .isNotEmpty
                                                            ? response.message
                                                            : AppStrings
                                                                .ratingFailed,
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.035,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "\${AppStrings.of(context).ratingError} \$e",
                                                      style: TextStyle(
                                                        fontSize:
                                                            screenWidth * 0.035,
                                                      ),
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: MyColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      screenWidth * 0.03,
                                                    ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.015,
                                              ),
                                            ),
                                            child: Text(
                                              AppStrings.send,
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.035,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: screenWidth * 0.05,
                            color: Colors.grey,
                          ),
                          SizedBox(width: screenWidth * 0.01),
                          Text(
                            AppStrings.rate,
                            style: TextStyle(
                              fontSize: screenWidth * 0.034,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
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
