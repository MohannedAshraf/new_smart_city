// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/screens/government_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GovernmentServiceDetails extends StatelessWidget {
  const GovernmentServiceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            'تجديد رخصة القيادة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('التراخيص', style: TextStyle(color: Colors.indigo)),
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
                          color: Colors.indigo.withOpacity(.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // width: MediaQuery.of(context).size.width - 30,
                        height: 200,
                        child: Center(
                          child: Icon(
                            Icons.description,
                            size: 90,
                            color: Colors.indigo,
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
                              padding: const EdgeInsets.fromLTRB(19, 0, 19, 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
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
                                      Icons.assignment,
                                      color: MyColors.dodgerBlue,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      ' الوثائق المطلوبة',

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

                            requirmentItem(' الوثائق المطلوبةالوثيقة 1'),

                            requirmentItem(
                              'Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain',
                            ),

                            requirmentItem('hg,edr vrl uav, '),

                            requirmentItem(
                              'الوثائق المطلوبة الوثائق المطلوبة الوثائق المطلوبة الوثائق المطلوبة',
                            ),
                          ],
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
                                      Icons.format_list_numbered,
                                      color: MyColors.dodgerBlue,
                                      size: 28,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'كيف تقدم طلبًا؟',

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

                            stepsItem('textt1', 'title1', '1'),

                            stepsItem('textt2', 'title2', '2'),

                            stepsItem(
                              'textt3  enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure',
                              'title3',
                              '3',
                            ),

                            stepsItem('textt3 ', 'title4', '4'),
                          ],
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),

                                      height: 80,
                                      width: 140,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          10,
                                          16,
                                          16,
                                          12,
                                        ),
                                        child: Text(
                                          '5-7 أيام عمل',
                                          style: TextStyle(
                                            color: const Color(0xFFE79420),
                                            fontSize: 20,
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
              onPressed: () {},
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
