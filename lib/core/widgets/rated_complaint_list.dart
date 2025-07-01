// ignore_for_file: use_build_context_synchronously

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_rating_issue.dart';
import 'package:citio/models/issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅

const String _baseUrl = 'https://cms-reporting.runasp.net/';

class RatedComplaintList extends StatelessWidget {
  final List<Values> issues;
  const RatedComplaintList({super.key, required this.issues});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // ✅
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: 140.h, // ✅
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r), // ✅
            ),
            margin: EdgeInsets.symmetric(vertical: 8.h), // ✅
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(24.w), // ✅
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r), // ✅
                    child:
                        issue.image != null
                            ? Image.network(
                              _baseUrl + issue.image!,
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 40.sp),
                            )
                            : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                              width: 80.w,
                              height: 80.h,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image, size: 40.sp),
                            ),
                  ),
                  SizedBox(width: 16.w), // ✅
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: TextStyle(
                            fontSize: 14.sp, // ✅
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h), // ✅
                        Text(
                          issue.description ?? '',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromARGB(255, 0, 3, 5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h), // ✅
                        Text(
                          'تم حلها',
                          style: TextStyle(
                            fontSize: 14.sp, // ✅
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w), // ✅
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
                                    16.r,
                                  ), // ✅
                                ),
                                title: Text(
                                  "تقييم المشكلة",
                                  style: TextStyle(fontSize: 16.sp), // ✅
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "من فضلك قيّم الخدمة التي قُدمت لك:",
                                      style: TextStyle(fontSize: 14.sp), // ✅
                                    ),
                                    SizedBox(height: 12.h), // ✅
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 30.sp, // ✅
                                      itemPadding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      itemBuilder:
                                          (context, _) => Icon(
                                            Icons.star,
                                            color: MyColors.themecolor,
                                            size: 24.sp,
                                          ),
                                      onRatingUpdate: (rating) {
                                        selectedRating = rating;
                                      },
                                    ),
                                    SizedBox(height: 16.h), // ✅
                                    TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "اكتب تعليقك هنا...",
                                        hintStyle: TextStyle(fontSize: 14.sp),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ), // ✅
                                        ),
                                        contentPadding: EdgeInsets.all(
                                          12.w,
                                        ), // ✅
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "إلغاء",
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.themecolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "إرسال",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
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
                                              style: TextStyle(fontSize: 14.sp),
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
                                                  fontSize: 14.sp,
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
                                                  fontSize: 14.sp,
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
                                              style: TextStyle(fontSize: 14.sp),
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
                            size: 20.sp,
                            color: Colors.grey,
                          ), // ✅
                          SizedBox(width: 4.w), // ✅
                          Text(
                            "Rate",
                            style: TextStyle(
                              fontSize: 13.sp,
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
