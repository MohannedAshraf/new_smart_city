// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/apply_service.dart';
import 'package:citio/screens/government_services.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GovernmentServiceDetails extends StatelessWidget {
  final int id;
  const GovernmentServiceDetails({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ServiceDetails>(
      future: MostRequestedServices().getServiceDetails(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ServiceDetails service = snapshot.data!;
          return Scaffold(
            backgroundColor: MyColors.offWhite,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                backgroundColor: MyColors.white,
                surfaceTintColor: MyColors.white,
                automaticallyImplyLeading: true,
                title: Text(
                  service?.serviceName ?? 'خطأ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Styles.govTabStyles[service!.category]?['color'] ??
                          MyColors.fadedGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service?.category ?? '',
                      style: TextStyle(
                        color:
                            Styles.govTabStyles[service!
                                .category]?['fontColor'] ??
                            MyColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              decoration: BoxDecoration(
                                color:
                                    Styles.govTabStyles[service!
                                        .category]?['color'] ??
                                    MyColors.whiteSmoke,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width - 30,
                              height: 200,
                              child: Center(
                                child: Icon(
                                  Styles.govTabStyles[service!
                                          .category]?['icon'] ??
                                      Icons.broken_image_rounded,
                                  size: 90,
                                  color:
                                      Styles.govTabStyles[service!
                                          .category]?['fontColor'] ??
                                      MyColors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width - 30,
                              //height: 200,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      16,
                                      16,
                                      12,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 14,
                                          child: Icon(
                                            Icons.info,
                                            color: MyColors.dodgerBlue,
                                            size: 28,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            maxLines: 1,
                                            'تفاصيل هذه الخدمة',

                                            style: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.start,
                                            //maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      19,
                                      0,
                                      19,
                                      20,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service?.description ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: ServiceContainer(
                              icon: Icons.assignment,
                              title: 'الوثائق المطلوبة',
                              content:
                                  service != null &&
                                          service!.requirements!.isNotEmpty
                                      ? service!.requirements!
                                          .map(
                                            (r) => RequirmentItem(
                                              text: r.fileName,
                                            ),
                                          )
                                          .toList()
                                      : [
                                        Text(
                                          'لا توجد مستندات مطلوبة',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Padding(
                    //         padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //             color: MyColors.white,
                    //             borderRadius: BorderRadius.circular(20),
                    //           ),
                    //           // width: MediaQuery.of(context).size.width - 30,
                    //           //height: 200,
                    //           child: Column(
                    //             children: [
                    //               Padding(
                    //                 padding: const EdgeInsets.fromLTRB(
                    //                   10,
                    //                   16,
                    //                   16,
                    //                   12,
                    //                 ),
                    //                 child: Row(
                    //                   children: [
                    //                     CircleAvatar(
                    //                       backgroundColor: MyColors.white,
                    //                       radius: 13,
                    //                       child: Icon(
                    //                         Icons.format_list_numbered,
                    //                         color: MyColors.dodgerBlue,
                    //                         size: 28,
                    //                       ),
                    //                     ),
                    //                     SizedBox(width: 8),
                    //                     Expanded(
                    //                       child: Text(
                    //                         'كيف تقدم طلبًا؟',

                    //                         style: const TextStyle(
                    //                           color: Colors.black87,
                    //                           fontSize: 18,
                    //                           fontWeight: FontWeight.bold,
                    //                         ),
                    //                         textAlign: TextAlign.start,
                    //                         //maxLines: 2,
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),

                    //               stepsItem(
                    //                 'أكمل النموذج الإلكتروني باستخدام بياناتك الشخصية.',
                    //                 'تقديم الطلب',
                    //                 '1',
                    //               ),

                    //               stepsItem(
                    //                 'قدّم نسخًا رقمية من جميع المستندات المطلوبة.',
                    //                 ' تحميل المستندات',
                    //                 '2',
                    //               ),

                    //               stepsItem(
                    //                 'أكمل عملية الدفع من خلال بوابة إلكترونية آمنة.',
                    //                 'دفع الرسوم',
                    //                 '3',
                    //               ),

                    //               stepsItem(
                    //                 'استلم الشهادة يدويًا أو بالبريد خلال مدة التنفيذ.',
                    //                 'title4',
                    //                 '4',
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // width: MediaQuery.of(context).size.width - 30,
                              //height: 200,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      16,
                                      16,
                                      12,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 14,
                                          child: Icon(
                                            Icons.access_time_filled,
                                            color: const Color(0xFFE79420),
                                            size: 28,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'مدة التنفيذ',

                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.justify,
                                                //maxLines: 2,
                                              ),
                                              Text(
                                                'الوقت المتوقع لإتمام العملية',
                                                style: const TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFE79420,
                                              ).withOpacity(.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),

                                            height: 80,
                                            width: 140,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                    10,
                                                    16,
                                                    16,
                                                    12,
                                                  ),
                                              child: Expanded(
                                                child: Text(
                                                  maxLines: 3,
                                                  textAlign: TextAlign.center,
                                                  service.time ??
                                                      'مدة التنفيذ غير متوفرة',
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFFE79420,
                                                    ),
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity,
              color: MyColors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(19, 8, 19, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApplyService()),
                      );
                    },
                    icon: const Icon(
                      Icons.description,
                      size: 20,
                      color: MyColors.white,
                    ),
                    label: const Text(
                      'اطلب هذه الخدمة',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.dodgerBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Padding requirmentItem(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 8, 19, 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 5,
            child: Text(''),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,

              style: const TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.justify,
              //maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Padding stepsItem(String text, String title, String num) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 8, 19, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 16,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                      //maxLines: 2,
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        //maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RequirmentItem extends StatelessWidget {
  final String text;

  const RequirmentItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 8, 19, 12),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 5,
            child: Text(''),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,

              style: const TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.justify,
              //maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class StepsItem extends StatelessWidget {
  final String num;
  final String title;
  final String text;
  const StepsItem({required this.text, required this.title, required this.num});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 8, 19, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 16,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                      //maxLines: 2,
                    ),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 3,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        //maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
