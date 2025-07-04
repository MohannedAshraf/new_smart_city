// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api

import 'dart:typed_data';

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/models/all_services_categories.dart';
import 'package:citio/models/available_services.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:citio/services/get_gov_service_image.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernmentServices extends StatefulWidget {
  const GovernmentServices({super.key});
  @override
  _GovernmentServicesState createState() => _GovernmentServicesState();
}

class _GovernmentServicesState extends State<GovernmentServices> {
  int selectedIndex = 0;
  Map<int, Uint8List?> imageCache = {};
  List<String> tabs = ['الكل'];
  List<AllServicesCategories> tabsList = [];
  List<AvailableServices> availableServices = [];
  bool tabsAreLoading = true;
  bool servicesLoading = true;
  String filter = '';
  int currenttab = 0;
  late ServiceDetails serviceDetails;

  @override
  void initState() {
    super.initState();
    MostRequestedServices().getAllCategories().then((fetchedItems) {
      setState(() {
        tabsList.addAll(fetchedItems);
        tabsAreLoading = false;
        tabs.addAll(tabsList.map((e) => e.name));
      });
    });
    MostRequestedServices().getAllServices().then((fetchedItems) {
      setState(() {
        availableServices.addAll(fetchedItems);
        servicesLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: Text(
            'الخدمات الحكومية',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(0.w, 10.h, 0.w, 0.h),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 8.h),
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            height: 45.h,
                            borderRadius: 5.r,
                            hintText: 'للبحث عن خدمة حكومية',
                            onSubmitted: (value) {
                              setState(() {
                                if (currenttab == 0) {
                                  searchService(value);
                                } else {
                                  searchFilteredService(
                                    value,
                                    tabs[currenttab],
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 6.h),
                      child:
                          tabsAreLoading
                              ? Row(
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.h,
                                    ),
                                    child: Container(
                                      width: 80.w,
                                      height: 35.h,
                                      decoration: BoxDecoration(
                                        color: MyColors.whiteSmoke,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  MyColors.gray,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : Row(
                                children: List.generate(tabsList.length, (
                                  index,
                                ) {
                                  return GovTabItem(
                                    title: tabs[index],
                                    isSelected: selectedIndex == index,
                                    onTap: () {
                                      selectedIndex = index;
                                      currenttab = index;
                                      filter = tabs[index];
                                      setState(() {
                                        if (index == 0) {
                                          loadData();
                                        } else {
                                          filterService(filter);
                                        }
                                      });

                                      //'مكان الfunction التانية يا لولو'
                                    },
                                  );
                                }),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
                child:
                    servicesLoading
                        ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 158 / 250,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: MyColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: const [
                                  BoxShadow(
                                    color: MyColors.whiteSmoke,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 130.h,
                                    decoration: BoxDecoration(
                                      color: MyColors.whiteSmoke,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.r),
                                        topRight: Radius.circular(12.r),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    height: 14.h,
                                    width: 100.w,
                                    color: MyColors.whiteSmoke,
                                  ),
                                  SizedBox(height: 6.h),
                                  Container(
                                    height: 12.h,
                                    width: 140.w,
                                    color: MyColors.whiteSmoke,
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0,
                                childAspectRatio: 158 / 250,
                              ),
                          itemCount: availableServices.length,
                          itemBuilder: (context, index) {
                            final service = availableServices[index];
                            return ServiceCard(
                              ontab: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => GovernmentServiceDetails(
                                          id: service.id,
                                        ),
                                  ),
                                );
                              },
                              imageIcon:
                                  imageCache[availableServices[index].id] !=
                                          null
                                      ? SizedBox(
                                        width: 60.w,
                                        height: 60.h,
                                        child: Image.memory(
                                          imageCache[availableServices[index]
                                              .id]!,
                                          fit: BoxFit.cover,
                                          // height: 60.h,
                                          // width: 60.w,
                                        ),
                                      )
                                      : FutureBuilder<Uint8List?>(
                                        future: ServiceImage().getImage(
                                          id: availableServices[index].id,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                              width: 60.w,
                                              height: 60.h,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }

                                          if (snapshot.hasData) {
                                            imageCache[availableServices[index]
                                                    .id] =
                                                snapshot.data!;
                                            return SizedBox(
                                              width: 60.w,
                                              height: 60.h,
                                              child: Image.memory(
                                                snapshot.data!,
                                              ),
                                            );
                                          }

                                          return const Icon(Icons.broken_image);
                                        },
                                      ),
                              color:
                                  Styles.govTabStyles[service
                                      .category]?['color'] ??
                                  MyColors.whiteSmoke,
                              fontColor:
                                  Styles.govTabStyles[service
                                      .category]?['fontColor'] ??
                                  MyColors.black,
                              category: service.category,
                              serviceName: service.serviceName,
                              details: service.description,
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadData() {
    MostRequestedServices().getAllServices().then((fetchedData) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedData);
      });
    });
  }

  void filterService(String category) {
    final currentfilter = category;
    MostRequestedServices().filterServices(currentfilter).then((fetchedItems) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }

  void searchService(String keyWord) {
    final search = keyWord;
    MostRequestedServices().searchServices(search).then((fetchedItems) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }

  void searchFilteredService(String keyWord, String category) {
    final currentfilter = category;
    final search = keyWord;
    MostRequestedServices().searchFilteredServices(search, currentfilter).then((
      fetchedItems,
    ) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }
}

class GovTabItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  const GovTabItem({
    super.key,
    required this.title,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(6.w, 0.h, 6.w, 5.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.primary : MyColors.whiteSmoke,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? MyColors.white : MyColors.black),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final Widget? imageIcon;
  final Color color;
  final Color fontColor;
  final String category;
  final String serviceName;
  final String details;
  final VoidCallback ontab;
  const ServiceCard({
    super.key,
    required this.imageIcon,
    required this.color,
    required this.category,
    required this.serviceName,
    required this.fontColor,
    required this.details,
    required this.ontab,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        width: double.infinity,

        margin: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 4.h),

        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(12.0.r),
          boxShadow: const [
            BoxShadow(
              color: MyColors.whiteSmoke,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Container(
                color: color,

                width: double.infinity,
                height: 100.h,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(12.r),
                    //   topRight: Radius.circular(12.r),
                    // ),
                    child: imageIcon,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0.h),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(6.w, 0.h, 6.w, 5.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(category, style: TextStyle(color: fontColor)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 2.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      serviceName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14.sp,
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
              padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      details,
                      style: TextStyle(
                        color: Color.fromARGB(221, 59, 58, 58),
                        fontSize: 12.0.sp,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
