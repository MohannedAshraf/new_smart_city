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
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 0.1,
              ),
              child: AppBar(
                backgroundColor: MyColors.white,
                surfaceTintColor: MyColors.white,
                automaticallyImplyLeading: true,
                title: Text(
                  service.serviceName,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.015,
                      0.h,
                      MediaQuery.of(context).size.width * 0.015,
                      MediaQuery.of(context).size.height * 0.00625,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Styles.govTabStyles[service.category]?['color'] ??
                          MyColors.fadedGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      service.category ?? '',
                      style: TextStyle(
                        color:
                            Styles.govTabStyles[service
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
                padding: EdgeInsets.fromLTRB(
                  0.w,
                  MediaQuery.of(context).size.height * 0.0125,
                  0.w,
                  0.w,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                            ),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                0.w,
                                0.h,
                                0.w,
                                MediaQuery.of(context).size.height * 0.0125,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Styles.govTabStyles[service
                                        .category]?['color'] ??
                                    MyColors.whiteSmoke,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Icon(
                                  Styles.govTabStyles[service
                                          .category]?['icon'] ??
                                      Icons.broken_image_rounded,
                                  size: 90,
                                  color:
                                      Styles.govTabStyles[service
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
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.025,
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                      MediaQuery.of(context).size.width * 0.04,
                                      MediaQuery.of(context).size.height *
                                          0.015,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.0350,
                                          child: Icon(
                                            Icons.info,
                                            color: MyColors.dodgerBlue,
                                            size:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.0350,
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.02,
                                        ),
                                        Expanded(
                                          child: Text(
                                            maxLines: 1,
                                            'تفاصيل هذه الخدمة',

                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.02250,
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
                                    padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width *
                                          0.0475,
                                      0.h,
                                      MediaQuery.of(context).size.width *
                                          0.0475,
                                      MediaQuery.of(context).size.height *
                                          0.0250,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service.description ?? '',
                                            style: TextStyle(
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01875,
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
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.0125,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                            ),
                            child: ServiceContainer(
                              icon: Icons.assignment,
                              title: 'الوثائق المطلوبة',
                              content:
                                  service.requirements!.isNotEmpty
                                      ? service.requirements!
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
                                            fontSize:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.02,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                              MediaQuery.of(context).size.width * 0.05,
                              MediaQuery.of(context).size.height * 0.00625,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.05,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.025,
                                      MediaQuery.of(context).size.height *
                                          0.025,
                                      MediaQuery.of(context).size.width * 0.04,
                                      MediaQuery.of(context).size.height *
                                          0.015,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 14,
                                          child: Icon(
                                            Icons.access_time_filled,
                                            color: const Color(0xFFE79420),
                                            size:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.0350,
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.02,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'مدة التنفيذ',

                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.02250,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.justify,
                                                //maxLines: 2,
                                              ),
                                              Text(
                                                'الوقت المتوقع لإتمام العملية',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.02,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.02,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.02,
                                            vertical:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.01,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFE79420,
                                              ).withOpacity(.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    MediaQuery.of(
                                                          context,
                                                        ).size.width *
                                                        0.05,
                                                  ),
                                            ),

                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.1,
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.1,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.025,
                                                MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.025,
                                                MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.04,
                                                MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.015,
                                              ),
                                              child: Text(
                                                maxLines: 3,
                                                textAlign: TextAlign.center,
                                                service.time ??
                                                    'مدة التنفيذ غير متوفرة',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFFE79420,
                                                  ),
                                                  fontSize:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.height *
                                                      0.01875,
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
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.0475,
                  MediaQuery.of(context).size.height * 0.01,
                  MediaQuery.of(context).size.width * 0.0475,
                  MediaQuery.of(context).size.height * 0.025,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.0625,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplyService(id: service.id),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.description,
                      size: MediaQuery.of(context).size.height * 0.025,
                      color: MyColors.white,
                    ),
                    label: Text(
                      'اطلب هذه الخدمة',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.021250,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.dodgerBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.0350,
                        ),
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

  Padding requirmentItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.01,
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: MediaQuery.of(context).size.width * 0.0125,
            child: Text(''),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Expanded(
            child: Text(
              text,

              style: TextStyle(
                color: Colors.black87,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
              textAlign: TextAlign.justify,
              //maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Padding stepsItem(
    BuildContext context,
    String text,
    String title,
    String num,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.01,
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: MediaQuery.of(context).size.width * 0.04,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: MediaQuery.of(context).size.height * 0.02250,
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
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
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
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.01,
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: MediaQuery.of(context).size.width * 0.0125,
            child: Text(''),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Expanded(
            child: Text(
              text,

              style: TextStyle(
                color: Colors.black87,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
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
  const StepsItem({
    super.key,
    required this.text,
    required this.title,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.01,
        MediaQuery.of(context).size.width * 0.0475,
        MediaQuery.of(context).size.height * 0.015,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: MediaQuery.of(context).size.width * 0.04,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: MediaQuery.of(context).size.height * 0.02250,
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
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: MediaQuery.of(context).size.height * 0.02,
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
