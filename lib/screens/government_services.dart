// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/models/all_services_categories.dart';
import 'package:citio/models/available_services.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:flutter/material.dart';

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
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            'الخدمات الحكومية',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 19, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomSearchBar(
                            height: 45,
                            borderRadius: 5,
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
                                borderRadius: BorderRadius.circular(5.0),
                                color: MyColors.whiteSmoke,
                              ),
                              margin: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: MyColors.gray,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                      child:
                          tabsAreLoading
                              ? Row(
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                    child: Container(
                                      width: 80,
                                      height: 35,
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
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: MyColors.whiteSmoke,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 14,
                                    width: 100,
                                    color: MyColors.whiteSmoke,
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    height: 12,
                                    width: 140,
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
                                //childAspectRatio: 0.60869,
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

  // void getServiceDetails(int id) {
  //   MostRequestedServices().getServiceDetails(id).then((fetchedService) {
  //     setState(() {
  //       serviceDetails = fetchedService;
  //     });
  //   });
  // }
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
        margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.dodgerBlue : MyColors.whiteSmoke,
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
        //height: 230,
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),

        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(12.0),
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                color: color,

                width: double.infinity,
                height: 130,
                child: Center(child: Icon(icon, size: 40, color: fontColor)),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(category, style: TextStyle(color: fontColor)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      serviceName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
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
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      details,
                      style: const TextStyle(
                        color: Color.fromARGB(221, 59, 58, 58),
                        fontSize: 12.0,
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
