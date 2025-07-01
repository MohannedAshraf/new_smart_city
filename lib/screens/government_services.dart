// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/models/all_services_categories.dart';
import 'package:citio/models/available_services.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/government_service_details.dart';
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
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.0625,
        ),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: Text(
            'الخدمات الحكومية',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.025,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          0.w,
          MediaQuery.of(context).size.height * 0.0125,
          0.w,
          0.h,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(
                0.w,
                0.h,
                0.w,
                MediaQuery.of(context).size.height * 0.01,
              ),
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.025,
                      0.h,
                      MediaQuery.of(context).size.width * 0.0475,
                      0.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            height:
                                MediaQuery.of(context).size.height * 0.05625,
                            borderRadius:
                                MediaQuery.of(context).size.width * 0.0125,
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.0125,
                                ),
                                color: MyColors.whiteSmoke,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: MyColors.gray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width * 0.04,
                        0.h,
                        MediaQuery.of(context).size.width * 0.04,
                        MediaQuery.of(context).size.height * 0.0075,
                      ),
                      child:
                          tabsAreLoading
                              ? Row(
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.height *
                                          0.0075,
                                    ),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.04375,
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
                                          setState(() {
                                            loadData();
                                          });
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
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.025,
                  0.h,
                  MediaQuery.of(context).size.width * 0.025,
                  0.h,
                ),
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
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.03,
                                ),
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
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.0375,
                                    decoration: BoxDecoration(
                                      color: MyColors.whiteSmoke,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                        ),
                                        topRight: Radius.circular(
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.0125,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.0175,
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.250,
                                    color: MyColors.whiteSmoke,
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.0075,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.015,
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
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
                              icon:
                                  Styles.govTabStyles[service
                                      .category]?['icon'] ??
                                  Icons.broken_image_rounded,
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
          color: isSelected ? MyColors.dodgerBlue : MyColors.whiteSmoke,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.05,
          ),
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
  final IconData icon;
  final Color color;
  final Color fontColor;
  final String category;
  final String serviceName;
  final String details;
  final VoidCallback ontab;
  const ServiceCard({
    super.key,
    required this.icon,
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

        margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.015,
          MediaQuery.of(context).size.height * 0.005,
          MediaQuery.of(context).size.width * 0.015,
          MediaQuery.of(context).size.height * 0.005,
        ),

        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(
            MediaQuery.of(context).size.width * 0.03,
          ),
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
                topLeft: Radius.circular(
                  MediaQuery.of(context).size.width * 0.03,
                ),
                topRight: Radius.circular(
                  MediaQuery.of(context).size.width * 0.03,
                ),
              ),
              child: Container(
                color: color,

                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.0375,
                child: Center(
                  child: Icon(
                    icon,
                    size: MediaQuery.of(context).size.height * 0.05,
                    color: fontColor,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.02,
                    MediaQuery.of(context).size.height * 0.01,
                    MediaQuery.of(context).size.width * 0.02,
                    0.h,
                  ),
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
                      color: color,
                      borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                    child: Text(category, style: TextStyle(color: fontColor)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * 0.025,
                MediaQuery.of(context).size.height * 0.005,
                MediaQuery.of(context).size.width * 0.025,
                MediaQuery.of(context).size.height * 0.0025,
              ),
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
                        fontSize: MediaQuery.of(context).size.height * 0.0175,
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
                MediaQuery.of(context).size.width * 0.025,
                MediaQuery.of(context).size.height * 0.0025,
                MediaQuery.of(context).size.width * 0.025,
                MediaQuery.of(context).size.height * 0.0125,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      details,
                      style: TextStyle(
                        color: Color.fromARGB(221, 59, 58, 58),
                        fontSize: MediaQuery.of(context).size.height * 0.015,
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
