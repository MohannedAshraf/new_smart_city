// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/apply_service.dart';
import 'package:citio/services/get_gov_service_image.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernmentServiceDetails extends StatefulWidget {
  final int id;
  const GovernmentServiceDetails({super.key, required this.id});

  @override
  State<GovernmentServiceDetails> createState() =>
      _GovernmentServiceDetailsState();
}

class _GovernmentServiceDetailsState extends State<GovernmentServiceDetails> {
  late Future<ServiceDetails> _serviceFuture;

  @override
  void initState() {
    super.initState();
    _serviceFuture = MostRequestedServices().getServiceDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: FutureBuilder<ServiceDetails>(
            future: _serviceFuture,
            builder: (context, snapshot) {
              return Text(
                snapshot.hasData
                    ? snapshot.data!.serviceName
                    : 'جاري التحميل...',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              );
            },
          ),
          centerTitle: true,
        ),
      ),
      body: FutureBuilder<ServiceDetails>(
        future: _serviceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('لا توجد بيانات للخدمة'));
          }

          final service = snapshot.data!;
          final color =
              Styles.govTabStyles[service.category]?['color'] ??
              MyColors.whiteSmoke;
          final icon =
              Styles.govTabStyles[service.category]?['icon'] ??
              Icons.broken_image_rounded;
          final fontColor =
              Styles.govTabStyles[service.category]?['fontColor'] ??
              MyColors.black;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: FutureBuilder<Uint8List?>(
                      future: ServiceImage().getImage(id: widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            width: 80.w,
                            height: 80.h,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          return SizedBox(
                            width: 80.w,
                            height: 80.h,
                            child: Image.memory(snapshot.data!),
                          );
                        }

                        return SizedBox(
                          width: 80.w,
                          height: 80.h,
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              'تفاصيل هذه الخدمة',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        service.description ?? '',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                ServiceContainer(
                  icon: Icons.assignment,
                  title: 'الوثائق المطلوبة',
                  content:
                      service.requirements!.isNotEmpty
                          ? service.requirements!
                              .map((r) => RequirmentItem(text: r.fileName))
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
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: MyColors.white,
                        radius: 14.r,
                        child: Icon(
                          Icons.access_time_filled,
                          color: const Color(0xFFE79420),
                          size: 28.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مدة التنفيذ',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'الوقت المتوقع لإتمام العملية',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        width: 140.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE79420).withOpacity(.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Text(
                            service.time ?? 'مدة التنفيذ غير متوفرة',
                            style: TextStyle(
                              color: const Color(0xFFE79420),
                              fontSize: 15.sp,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<ServiceDetails>(
        future: _serviceFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          final service = snapshot.data!;
          return Container(
            color: MyColors.white,
            padding: EdgeInsets.fromLTRB(19.w, 8.h, 19.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ApplyService(
                            id: service.id,
                            title: service.serviceName,
                          ),
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
          );
        },
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
          CircleAvatar(backgroundColor: MyColors.dodgerBlue, radius: 5.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: 16.sp),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
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
                      style: TextStyle(color: Colors.black87, fontSize: 16.sp),
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
