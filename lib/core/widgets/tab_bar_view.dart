// ignore_for_file: library_private_types_in_public_api

import 'package:citio/core/utils/variables.dart';

import 'package:citio/models/request.dart';
import 'package:citio/screens/apply_service.dart';
import 'package:citio/services/get_requests_by_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarViewItem extends StatefulWidget {
  final String title;

  const TabBarViewItem({super.key, required this.title});
  @override
  _TabBarViewItemState createState() => _TabBarViewItemState();
}

class _TabBarViewItemState extends State<TabBarViewItem> {
  @override
  Widget build(BuildContext context) {
    Future<List<Request>> future;
    if (widget.title == 'الجميع') {
      future =
          RequestsByStatus()
              .getAllRequests(); // هنا تحط ال API اللي بترجع كل الطلبات
    } else {
      future = RequestsByStatus().getRequestsByStatus(status: widget.title);
    }
    return FutureBuilder<List<Request>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          List<Request> requests = snapshot.data!;
          if (requests.isEmpty) {
            return emptyCategory();
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: requests.length,
            itemBuilder: (context, index) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: CustomCard(
                  request: requests[index],
                  cardTitle: widget.title,
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Center emptyCategory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MyColors.white,
            radius: 45.r,
            child: Icon(
              Icons.inventory,
              color: MyColors.fadedGrey,
              size: 40.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'لا يوجد طلبات حاليا',
              style: TextStyle(fontSize: 16.sp, color: MyColors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'هذا الستخدم لو يرسل أي طلب',
              style: TextStyle(fontSize: 16.sp, color: MyColors.gray),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomCard extends StatefulWidget {
  CustomCard({required this.request, required this.cardTitle, super.key});
  Request request;
  String cardTitle;
  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow:
              isHovered
                  ? [
                    const BoxShadow(
                      color: MyColors.fadedGrey,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 4),
                    ),
                  ]
                  : [
                    const BoxShadow(
                      color: MyColors.white,
                      blurRadius: 3,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    ),
                  ],
        ),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            child: Row(
              children: [
                // Icon Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 25),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Styles.requestsStyle[widget
                                  .request
                                  .requestStatus]?['color'] ??
                              MyColors.gray,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: 50,
                        height: 50,
                        child: Center(
                          child: Icon(
                            Styles.requestsStyle[widget
                                    .request
                                    .requestStatus]?['icon'] ??
                                Icons.broken_image,
                            size: 23,
                            color:
                                Styles.requestsStyle[widget
                                    .request
                                    .requestStatus]?['fontColor'] ??
                                MyColors.fadedGrey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Spacer
                SizedBox(width: 10),

                // Text Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(4, 2, 15, 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.request.serviceName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: MyColors.fontcolor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(6, 0, 6, 5),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Styles.requestsStyle[widget
                                        .request
                                        .requestStatus]?['color'] ??
                                    MyColors.fadedGrey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                widget.request.requestStatus,
                                style: TextStyle(
                                  color:
                                      Styles.requestsStyle[widget
                                          .request
                                          .requestStatus]?['fontColor'] ??
                                      MyColors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Text(
                                  widget.request.responseText,
                                  style: TextStyle(
                                    color:
                                        Styles.requestsStyle[widget
                                            .request
                                            .requestStatus]?['fontColor'] ??
                                        MyColors.black,
                                    fontSize: 14,
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  widget.request.requestDate,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(134, 133, 133, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            widget.request.requestStatus == 'Rejected'
                                ? Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 30.h,
                                        width: 90.w,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => ApplyService(
                                                      id:
                                                          widget
                                                              .request
                                                              .serviceId,
                                                    ),
                                              ),
                                            );
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                  MyColors.inProgress,
                                                ),
                                            padding: WidgetStateProperty.all(
                                              EdgeInsets.zero,
                                            ),
                                          ),
                                          child: Text(
                                            'اعادة الطلب',
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: MyColors.white,
                                              fontSize: 13.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
