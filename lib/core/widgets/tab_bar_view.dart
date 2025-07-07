// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:typed_data';

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/models/request.dart';
import 'package:citio/screens/apply_service.dart';
import 'package:citio/services/get_file.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:citio/services/get_requests_by_status.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TabBarViewItem extends StatefulWidget {
  final String title;

  const TabBarViewItem({super.key, required this.title});

  @override
  _TabBarViewItemState createState() => _TabBarViewItemState();
}

class _TabBarViewItemState extends State<TabBarViewItem> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Future<List<Request>> future;
    if (widget.title == 'الجميع') {
      future = RequestsByStatus().getAllRequests();
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
            return emptyCategory(screenWidth);
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              return CustomCard(
                request: requests[index],
                cardTitle: widget.title,
                screenWidth: screenWidth,
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Center emptyCategory(double screenWidth) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MyColors.white,
            radius: screenWidth * 0.12,
            child: Icon(
              Icons.inventory,
              color: MyColors.fadedGrey,
              size: screenWidth * 0.1,
            ),
          ),
          SizedBox(height: screenWidth * 0.05),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Text(
              AppStrings.noGovRequests,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: MyColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: screenWidth * 0.025),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Text(
              AppStrings.userHasNoRequests,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: MyColors.gray,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final Request request;
  final String cardTitle;
  final double screenWidth;

  const CustomCard({
    super.key,
    required this.request,
    required this.cardTitle,
    required this.screenWidth,
  });

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isHovered = false;
  final Map<int, PlatformFile> oldFiles = {};
  final List<RequiredFields> oldServiceData = [];
  final List<RequiredFiles> files = [];
  @override
  Widget build(BuildContext context) {
    final sw = widget.screenWidth;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        margin: EdgeInsets.symmetric(
          horizontal: sw * 0.04,
          vertical: sw * 0.025,
        ),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(sw * 0.04),
          boxShadow: [
            BoxShadow(
              color: isHovered ? MyColors.fadedGrey : MyColors.whiteSmoke,
              blurRadius: isHovered ? 10 : 2,
              spreadRadius: isHovered ? 1 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.all(sw * 0.02),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: sw * 0.025,
                        bottom: sw * 0.06,
                      ),
                      child: Container(
                        width: sw * 0.13,
                        height: sw * 0.13,
                        decoration: BoxDecoration(
                          color:
                              Styles.requestsStyle[widget
                                  .request
                                  .requestStatus]?['color'] ??
                              MyColors.gray,
                          borderRadius: BorderRadius.circular(sw * 0.04),
                        ),
                        child: Icon(
                          Styles.requestsStyle[widget
                                  .request
                                  .requestStatus]?['icon'] ??
                              Icons.broken_image,
                          size: sw * 0.06,
                          color:
                              Styles.requestsStyle[widget
                                  .request
                                  .requestStatus]?['fontColor'] ??
                              MyColors.fadedGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: sw * 0.025),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: sw * 0.02, left: sw * 0.04),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.request.serviceName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: MyColors.fontcolor,
                                  fontSize: sw * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: sw * 0.03,
                                vertical: sw * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Styles.requestsStyle[widget
                                        .request
                                        .requestStatus]?['color'] ??
                                    MyColors.fadedGrey,
                                borderRadius: BorderRadius.circular(sw * 0.05),
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: sw * 0.01),
                          child: Text(
                            widget.request.responseText,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: sw * 0.037,
                              color:
                                  Styles.requestsStyle[widget
                                      .request
                                      .requestStatus]?['fontColor'] ??
                                  MyColors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.request.requestDate,
                              style: TextStyle(
                                color: const Color.fromRGBO(134, 133, 133, 1),
                                fontSize: sw * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            if (widget.request.requestStatus == 'Rejected')
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ApplyService(
                                            id: widget.request.serviceId,
                                            title: widget.request.serviceName,
                                          ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  backgroundColor: MyColors.inProgress,
                                  minimumSize: Size(sw * 0.24, sw * 0.09),
                                ),
                                child: Text(
                                  AppStrings.resubmitRequest,
                                  style: TextStyle(
                                    fontSize: sw * 0.035,
                                    color: MyColors.white,
                                  ),
                                ),
                              ),
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

  Future<void> fetchOldData(int requestId) async {
    try {
      final requestDetails = await MostRequestedServices().getAttachedFields(
        requestId,
      );
      final fetchedfiles = await ServiceFile().getFile(id: requestId);
      final files = await MostRequestedServices().getAttachedFiles(requestId);

      if (files != null && files.isNotEmpty) {
        setState(() {
          // for (var file in files) {
          //   Uint8List fileBytes = base64Decode(file.base64Content);
          //   oldFiles[file.id] = PlatformFile(
          //     name: file.fileName,
          //     size: file.bytes.length,
          //     bytes: file.bytes,
          //   );
          // }
        });
      }

      if (requestDetails != null && requestDetails.isNotEmpty) {
        setState(() {
          oldServiceData.addAll(requestDetails);
        });
      }
    } catch (e) {
      print('Error fetching old data: $e');
    }
  }
}
