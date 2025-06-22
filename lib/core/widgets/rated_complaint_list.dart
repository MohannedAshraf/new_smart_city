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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

        return SizedBox(
          height: 140,
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        issue.image != null
                            ? Image.network(
                              _baseUrl + issue.image!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 40),
                            )
                            : Image.network(
                              'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 40),
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
                            color: Color.fromARGB(255, 0, 3, 5),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'تم حلها',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text("تقييم المشكلة"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "من فضلك قيّم الخدمة التي قُدمت لك:",
                                    ),
                                    const SizedBox(height: 12),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 30,
                                      itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      itemBuilder:
                                          (context, _) => const Icon(
                                            Icons.star,
                                            color: MyColors.themecolor,
                                          ),
                                      onRatingUpdate: (rating) {
                                        selectedRating = rating;
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                      controller: commentController,
                                      maxLines: 3,
                                      decoration: InputDecoration(
                                        hintText: "اكتب تعليقك هنا...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.all(
                                          12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("إلغاء"),
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.themecolor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "إرسال",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      final comment =
                                          commentController.text.trim();

                                      if (selectedRating == 0.0) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "من فضلك اختر تقييم قبل الإرسال ⭐",
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
                                            // ignore: use_build_context_synchronously
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "تم إرسال تقييمك بنجاح ✅",
                                              ),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(
                                            // ignore: use_build_context_synchronously
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                response.message.isNotEmpty
                                                    ? response.message
                                                    : "فشل في إرسال التقييم",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          // ignore: use_build_context_synchronously
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "حدث خطأ أثناء الإرسال: $e",
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
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 20, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            "Rate",
                            style: TextStyle(fontSize: 13, color: Colors.grey),
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
