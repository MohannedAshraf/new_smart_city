// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_rating_issue.dart';
import 'package:citio/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class RatedComplaintList extends StatelessWidget {
  final List<Values> issues;
  const RatedComplaintList({super.key, required this.issues});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ), // ✅
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.05, // ✅
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04,
              ), // ✅
            ),
            margin: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.01,
            ), // ✅
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.06,
              ), // ✅
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.02,
                    ), // ✅
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ), // ✅
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height *
                                0.0175, // ✅
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0075,
                        ), // ✅
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                            color: const Color.fromARGB(255, 0, 3, 5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0075,
                        ), // ✅
                        Text(
                          'تم حلها',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height *
                                0.0175, // ✅
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ), // ✅
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
                                    MediaQuery.of(context).size.width * 0.04,
                                  ), // ✅
                                ),
                                title: Text(
                                  "تقييم المشكلة",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                        0.02,
                                  ), // ✅
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "من فضلك قيّم الخدمة التي قُدمت لك:",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                            0.0175,
                                      ), // ✅
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.015,
                                    ), // ✅
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize:
                                          MediaQuery.of(context).size.height *
                                          0.0375, // ✅
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                            0.01,
                                      ),
                                      itemBuilder:
                                          (context, _) => Icon(
                                            Icons.star,
                                            color: MyColors.themecolor,
                                            size:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.03,
                                          ),
                                      onRatingUpdate: (rating) {
                                        selectedRating = rating;
                                      },
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.025,
                                    ), // ✅
                                    TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "اكتب تعليقك هنا...",
                                        hintStyle: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.0175,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                          ), // ✅
                                        ),
                                        contentPadding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                        ), // ✅
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "إلغاء",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                            0.0175,
                                      ),
                                    ),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.themecolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.02,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "إرسال",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                            0.0175,
                                      ),
                                    ),
                                    onPressed: () async {
                                      final comment =
                                          commentController.text.trim();

                                      if (selectedRating == 0.0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "من فضلك اختر تقييم قبل الإرسال ⭐",
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.0175,
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
                                        final response = await feedbackService
                                            .sendFeedback(
                                              comment: comment,
                                              rateValue: selectedRating.toInt(),
                                            );

                                        if (response.isSuccess) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "تم إرسال تقييمك بنجاح ✅",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.0175,
                                                ),
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                response.message.isNotEmpty
                                                    ? response.message
                                                    : "فشل في إرسال التقييم",
                                                style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.0175,
                                                ),
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "حدث خطأ أثناء الإرسال: $e",
                                              style: TextStyle(
                                                fontSize:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.0175,
                                              ),
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: MediaQuery.of(context).size.height * 0.025,
                            color: Colors.grey,
                          ), // ✅
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ), // ✅
                          Text(
                            "Rate",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.01625,
                              color: Colors.grey,
                            ), // ✅
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
