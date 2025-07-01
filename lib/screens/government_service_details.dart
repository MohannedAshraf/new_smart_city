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
              preferredSize: Size.fromHeight(80.h),
              child: AppBar(
                backgroundColor: MyColors.white,
                surfaceTintColor: MyColors.white,
                automaticallyImplyLeading: true,
                title: Text(
                  service.serviceName,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(6.w, 0.h, 6.w, 5.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
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
                padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 0.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 5.h),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 10.h),
                              decoration: BoxDecoration(
                                color:
                                    Styles.govTabStyles[service
                                        .category]?['color'] ??
                                    MyColors.whiteSmoke,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              height: 200.h,
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
                            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      10.w,
                                      16.h,
                                      16.w,
                                      12.h,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 14.r,
                                          child: Icon(
                                            Icons.info,
                                            color: MyColors.dodgerBlue,
                                            size: 28.sp,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Text(
                                            maxLines: 1,
                                            'تفاصيل هذه الخدمة',

                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 18.sp,
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
                                      19.w,
                                      0.h,
                                      19.w,
                                      20.h,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            service.description ?? '',
                                            style: TextStyle(
                                              fontSize: 15.sp,
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
                    SizedBox(height: 10.h),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 5.h),
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
                                            fontSize: 16.sp,
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
                            padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      10.w,
                                      16.h,
                                      16.w,
                                      12.h,
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: MyColors.white,
                                          radius: 14,
                                          child: Icon(
                                            Icons.access_time_filled,
                                            color: const Color(0xFFE79420),
                                            size: 28.sp,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'مدة التنفيذ',

                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.justify,
                                                //maxLines: 2,
                                              ),
                                              Text(
                                                'الوقت المتوقع لإتمام العملية',
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16.sp,
                                                ),
                                                textAlign: TextAlign.start,
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.w,
                                            vertical: 8.h,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFFE79420,
                                              ).withOpacity(.1),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),

                                            height: 80.h,
                                            width: 140.w,
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                10.w,
                                                16.h,
                                                16.w,
                                                12.h,
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
                                                  fontSize: 15.sp,
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
                padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 16.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.h,
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
                      size: 20.sp,
                      color: MyColors.white,
                    ),
                    label: Text(
                      'اطلب هذه الخدمة',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: MyColors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.dodgerBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
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
      padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 5.r,
            child: Text(''),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,

              style: TextStyle(color: Colors.black87, fontSize: 16.sp),
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
      padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 16.r,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.sp,
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
                          fontSize: 16.sp,
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
      padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 5.r,
            child: Text(''),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,

              style: TextStyle(color: Colors.black87, fontSize: 16.sp),
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
      padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 12.h),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.dodgerBlue,
            radius: 16.r,
            child: Text(
              num,
              style: const TextStyle(
                color: MyColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18.sp,
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
                          fontSize: 16.sp,
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
