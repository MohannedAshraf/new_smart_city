// ignore_for_file: unused_import, unnecessary_import, deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:typed_data';

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/apply_service.dart';
import 'package:citio/services/get_gov_service_image.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';

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

  double wp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  double hp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(hp(context, 10)), // حوالي 80px
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
                    : AppStrings.loading,
                style: TextStyle(
                  fontSize: wp(context, 5),
                  fontWeight: FontWeight.bold,
                ),
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
            return Center(
              child: Text('${AppStrings.errorOccurred5}${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text(AppStrings.noData5));
          }

          final service = snapshot.data!;
          final color =
              Styles.govTabStyles[service.category]?['color'] ??
              MyColors.whiteSmoke;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: wp(context, 5),
              vertical: hp(context, 2),
            ),
            child: Column(
              children: [
                Container(
                  height: hp(context, 25),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(wp(context, 5)),
                  ),
                  child: Center(
                    child: FutureBuilder<Uint8List?>(
                      future: ServiceImage().getImage(id: widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            width: wp(context, 20),
                            height: hp(context, 10),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          return SizedBox(
                            width: wp(context, 20),
                            height: hp(context, 10),
                            child: Image.memory(snapshot.data!),
                          );
                        }

                        return SizedBox(
                          width: wp(context, 20),
                          height: hp(context, 10),
                          child: const Icon(Icons.broken_image),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: hp(context, 1.5)),
                Container(
                  padding: EdgeInsets.all(wp(context, 5)),
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(wp(context, 5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: MyColors.white,
                            radius: wp(context, 3.5),
                            child: Icon(
                              Icons.info,
                              color: MyColors.primary,
                              size: wp(context, 7),
                            ),
                          ),
                          SizedBox(width: wp(context, 2)),
                          Expanded(
                            child: Text(
                              AppStrings.serviceDetailsTitle,
                              style: TextStyle(
                                fontSize: wp(context, 4.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: hp(context, 1)),
                      Text(
                        service.description ?? '',
                        style: TextStyle(
                          fontSize: wp(context, 4),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: hp(context, 1.5)),
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
                              AppStrings.noDocumentsRequired,
                              style: TextStyle(
                                fontSize: wp(context, 4),
                                color: Colors.black54,
                              ),
                            ),
                          ],
                ),
                SizedBox(height: hp(context, 1.5)),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.circular(wp(context, 5)),
                  ),
                  padding: EdgeInsets.all(wp(context, 5)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: MyColors.white,
                        radius: wp(context, 3.5),
                        child: Icon(
                          Icons.access_time_filled,
                          color: const Color(0xFFE79420),
                          size: wp(context, 7),
                        ),
                      ),
                      SizedBox(width: wp(context, 2)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.executionDuration,
                              style: TextStyle(
                                fontSize: wp(context, 4.5),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppStrings.expectedTime,
                              style: TextStyle(fontSize: wp(context, 4)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(wp(context, 2)),
                        width: wp(context, 35),
                        height: hp(context, 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE79420).withOpacity(.1),
                          borderRadius: BorderRadius.circular(wp(context, 5)),
                        ),
                        child: Center(
                          child: Text(
                            service.time ?? AppStrings.durationUnavailable,
                            style: TextStyle(
                              color: const Color(0xFFE79420),
                              fontSize: wp(context, 4),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: hp(context, 3)),
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
            padding: EdgeInsets.fromLTRB(
              wp(context, 5),
              hp(context, 1.5),
              wp(context, 5),
              hp(context, 2),
            ),
            child: SizedBox(
              width: double.infinity,
              height: hp(context, 6),
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
                  size: wp(context, 4),
                  color: MyColors.white,
                ),
                label: Text(
                  AppStrings.requestService,
                  style: TextStyle(
                    fontSize: wp(context, 4.5),
                    fontWeight: FontWeight.bold,
                    color: MyColors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(wp(context, 3)),
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

  double wp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  double hp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        wp(context, 5),
        hp(context, 1.5),
        wp(context, 5),
        hp(context, 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: MyColors.primary,
            radius: wp(context, 1.5),
          ),
          SizedBox(width: wp(context, 2)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black87, fontSize: wp(context, 4)),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

Padding requirmentItem(String text, BuildContext context) {
  double wp(double p) => MediaQuery.of(context).size.width * (p / 100);
  double hp(double p) => MediaQuery.of(context).size.height * (p / 100);

  return Padding(
    padding: EdgeInsets.fromLTRB(wp(5), hp(1.5), wp(5), hp(2)),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: MyColors.primary,
          radius: wp(1.5),
          child: Text(''),
        ),
        SizedBox(width: wp(2)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.black87, fontSize: wp(4)),
            textAlign: TextAlign.justify,
            //maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

Padding stepsItem(String text, String title, String num, BuildContext context) {
  double wp(double p) => MediaQuery.of(context).size.width * (p / 100);
  double hp(double p) => MediaQuery.of(context).size.height * (p / 100);

  return Padding(
    padding: EdgeInsets.fromLTRB(wp(5), hp(1.5), wp(5), hp(2)),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: MyColors.primary,
          radius: wp(4),
          child: Text(
            num,
            style: const TextStyle(
              color: MyColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: wp(2)),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: wp(4.5),
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
                      style: TextStyle(color: Colors.black87, fontSize: wp(4)),
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
