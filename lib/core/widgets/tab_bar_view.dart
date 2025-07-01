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
        if (snapshot.hasData) {
          List<Request> requests = snapshot.data!;
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
        margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.0375,
          MediaQuery.of(context).size.height * 0.0125,
          MediaQuery.of(context).size.width * 0.0375,
          MediaQuery.of(context).size.height * 0.0125,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.0375,
          ),
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
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.0175,
              vertical: MediaQuery.of(context).size.height * 0.00875,
            ),
            child: Row(
              children: [
                // Icon Section
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        0,
                        MediaQuery.of(context).size.height * 0.0125,
                        MediaQuery.of(context).size.width * 0.0625,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Styles.requestsStyle[widget
                                  .request
                                  .requestStatus]?['color'] ??
                              MyColors.gray,
                          borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.width * 0.0375,
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 0.125,
                        height: MediaQuery.of(context).size.height * 0.0625,
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.025),

                // Text Content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.01,
                      MediaQuery.of(context).size.height * 0.0025,
                      MediaQuery.of(context).size.width * 0.0375,
                      MediaQuery.of(context).size.height * 0.0025,
                    ),
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
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * 0.015,
                                0.h,
                                MediaQuery.of(context).size.width * 0.015,
                                MediaQuery.of(context).size.height * 0.00625,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
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
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.00625,
                        ),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.0375,
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.225,
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
                                              fontSize:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.01625,
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
