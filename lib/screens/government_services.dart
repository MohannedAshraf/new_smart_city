// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api

import 'dart:typed_data';
import 'package:citio/core/utils/project_strings.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/models/all_services_categories.dart';
import 'package:citio/models/available_services.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:citio/services/get_gov_service_image.dart';
import 'package:citio/services/get_most_requested_services.dart';

class GovernmentServices extends StatefulWidget {
  const GovernmentServices({super.key});
  @override
  _GovernmentServicesState createState() => _GovernmentServicesState();
}

class _GovernmentServicesState extends State<GovernmentServices> {
  int selectedIndex = 0;
  Map<int, Uint8List?> imageCache = {};
  List<String> tabs = [AppStrings.all];
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.07),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            AppStrings.govServices,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.01),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: screenHeight * 0.01),
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: screenHeight * 0.015,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            height: screenHeight * 0.06,
                            borderRadius: 5,
                            hintText: AppStrings.searchGovService,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                      ),
                      child:
                          tabsAreLoading
                              ? Row(
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01,
                                    ),
                                    child: Container(
                                      width: screenWidth * 0.18,
                                      height: screenHeight * 0.045,
                                      decoration: BoxDecoration(
                                        color: MyColors.whiteSmoke,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
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
                                children: List.generate(
                                  tabsList.length,
                                  (index) => GovTabItem(
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
                                    },
                                  ),
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
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
                          itemBuilder:
                              (context, index) =>
                                  PlaceholderCard(screenHeight: screenHeight),
                        )
                        : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
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
                                  imageCache[service.id] != null
                                      ? Image.memory(
                                        imageCache[service.id]!,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      )
                                      : FutureBuilder<Uint8List?>(
                                        future: ServiceImage().getImage(
                                          id: service.id,
                                        ),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                          if (snapshot.hasData) {
                                            imageCache[service.id] =
                                                snapshot.data!;
                                            return Image.memory(
                                              snapshot.data!,
                                              width: 60,
                                              height: 60,
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
    MostRequestedServices().filterServices(category).then((fetchedItems) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }

  void searchService(String keyWord) {
    MostRequestedServices().searchServices(keyWord).then((fetchedItems) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }

  void searchFilteredService(String keyWord, String category) {
    MostRequestedServices().searchFilteredServices(keyWord, category).then((
      fetchedItems,
    ) {
      setState(() {
        availableServices.clear();
        availableServices.addAll(fetchedItems);
      });
    });
  }
}

class PlaceholderCard extends StatelessWidget {
  final double screenHeight;
  const PlaceholderCard({super.key, required this.screenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12),
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
            height: screenHeight * 0.16,
            decoration: const BoxDecoration(
              color: MyColors.whiteSmoke,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(height: 14, width: 100, color: MyColors.whiteSmoke),
          const SizedBox(height: 6),
          Container(height: 12, width: 140, color: MyColors.whiteSmoke),
        ],
      ),
    );
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
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.primary : MyColors.whiteSmoke,
          borderRadius: BorderRadius.circular(20),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: ontab,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(
          screenWidth * 0.015,
          screenHeight * 0.01,
          screenWidth * 0.015,
          screenHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
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
                topLeft: Radius.circular(screenWidth * 0.03),
                topRight: Radius.circular(screenWidth * 0.03),
              ),
              child: Container(
                color: color,
                width: double.infinity,
                height: screenHeight * 0.13,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                    child: imageIcon,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.02,
                    screenHeight * 0.01,
                    screenWidth * 0.02,
                    0,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.015,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    child: Text(category, style: TextStyle(color: fontColor)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.025,
                screenHeight * 0.005,
                screenWidth * 0.025,
                screenHeight * 0.002,
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
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.025,
                screenHeight * 0.002,
                screenWidth * 0.025,
                screenHeight * 0.015,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      details,
                      style: TextStyle(
                        color: const Color.fromARGB(221, 59, 58, 58),
                        fontSize: screenWidth * 0.03,
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
