// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';

import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/all_vendors.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:citio/screens/vendor_profile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllVendorsScreen extends StatefulWidget {
  const AllVendorsScreen({super.key});

  @override
  _AllVendorsScreenState createState() => _AllVendorsScreenState();
}

class _AllVendorsScreenState extends State<AllVendorsScreen> {
  final ScrollController scrollController = ScrollController();

  VendorMode currentMode = VendorMode.normal;
  String searchValue = '';
  List<String> filterValues = [];
  String url = '0';
  List<String> selectedCategories = [];
  Map<String, String> categories = {
    "الهواتف": "Mobile Devices",
    "التصميم الداخلي": "Interior Design",
    "مراكز التجميل": "Beauty Salon",
    "الأدوات الرياضية": "Sports Equipment",
    "خدمة السيارات": "Auto Service",
    "زهور": "Florist",
    "كتب": "Book Store",
    "مستلزمات الحيوانات": "Pet Store",
    "منتجات التجميل": "Cosmetics",
    "الخدمات المنزلية": "Home Services",
    "الطعام": "Food Services",
    "تنسيق الحدائق": "Gardening",
    "السباكة": "Plumbing Services",
    "الكترونيات": "Electronics",
    "أدوات الصيانة": "Hardware Tools",
    "أعمال يدوية": "Handmade Crafts",
    "خدمات التنظيف": "Cleaning Services",
    "خدمات الIT": "IT Services",
    "دمى وألعاب": "Toys & Games",
    "متاجر الملابس": "Fashion Retail",
    "تنظيم الفعاليات": "Event Planning",
    "مطاعم": "Restaurant",
  };

  List<Items> vendors = [];
  int pageNumber = 1;
  int totalPages = 1000000;
  bool isLoading = false;
  bool isSearching = false;
  bool isFiltering = false;

  bool filterButtonSelected = false;

  @override
  void initState() {
    super.initState();
    GetVendor().getAllVendors(pageNumber).then((fetchedItems) {
      setState(() {
        vendors.addAll(fetchedItems.items);
        totalPages = fetchedItems.totalPages;
      });
    });
    scrollController.addListener(loadMoreData);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        title: Padding(
          padding: EdgeInsets.fromLTRB(
            0,
            screenHeight * 0.015,
            0,
            screenHeight * 0.015,
          ),
          child: Text(
            AppStrings.vendorsScreenTitle,
            style: TextStyle(
              color: MyColors.black,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.012),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        screenHeight * 0.02,
                        screenWidth * 0.015,
                        screenHeight * 0.02,
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _showFilterModal(context);
                          });
                        },
                        icon: Icon(
                          Icons.tune,
                          color: MyColors.black,
                          size: screenWidth * 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.04,
                      screenHeight * 0.01,
                      screenWidth * 0.015,
                      screenHeight * 0.01,
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        searchBarTheme: SearchBarThemeData(
                          backgroundColor: WidgetStateProperty.all(
                            MyColors.whiteSmoke,
                          ),
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(color: MyColors.black),
                          ),
                          shadowColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                      ),
                      child: SearchBar(
                        hintText: AppStrings.searchHintText,
                        hintStyle: WidgetStateProperty.all(
                          const TextStyle(color: MyColors.gray),
                        ),
                        leading: const Icon(Icons.search, color: MyColors.gray),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.04,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            searchValue = value.trim();
                          });

                          if (searchValue.isEmpty &&
                              selectedCategories.isEmpty) {
                            setState(() {
                              currentMode = VendorMode.normal;
                              vendors.clear();
                              pageNumber = 1;
                            });
                            GetVendor().getAllVendors(pageNumber).then((
                              fetchedItems,
                            ) {
                              setState(() {
                                vendors.addAll(fetchedItems.items);
                                totalPages = fetchedItems.totalPages;
                                isLoading = false;
                              });
                            });
                          } else if (searchValue.isEmpty &&
                              selectedCategories.isNotEmpty) {
                            filterVendors(
                              selectedCategories
                                  .map((key) => categories[key]!)
                                  .toList(),
                            );
                          } else if (searchValue.isNotEmpty &&
                              selectedCategories.isEmpty) {
                            searchVendors(searchValue);
                          } else {
                            searchAndFilterVendors(
                              searchValue,
                              selectedCategories
                                  .map((key) => categories[key]!)
                                  .toList(),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VendorProfile(id: vendors[index].id),
                        ),
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        vendorCard(index),
                        if (index == vendors.length - 1 && isLoading)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.025,
                              vertical: screenHeight * 0.015,
                            ),
                            child: SpinKitFadingCircle(
                              color: MyColors.mintgreen,
                              size: screenWidth * 0.1,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card vendorCard(int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      margin: EdgeInsets.fromLTRB(
        screenWidth * 0.05,
        screenHeight * 0.012,
        screenWidth * 0.05,
        screenHeight * 0.01,
      ),
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.37,
        child: Column(
          children: [
            // الغلاف + صورة البروفايل
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.05),
                    topRight: Radius.circular(screenWidth * 0.05),
                  ),
                  child:
                      vendors[index].coverImage != null
                          ? Image.network(
                            Urls.serviceProviderbaseUrl +
                                vendors[index].coverImage!,
                            width: double.infinity,
                            height: screenHeight * 0.165,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return SizedBox(
                                height: screenHeight * 0.165,
                                width: double.infinity,
                                child: const Image(
                                  image: AssetImage(MyAssetsImage.brokenImage),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            MyAssetsImage.brokenImage,
                            width: double.infinity,
                            height: screenHeight * 0.165,
                            fit: BoxFit.cover,
                          ),
                ),
                Positioned(
                  top: screenHeight * 0.11,
                  left: screenWidth * 0.05,
                  child: CircleAvatar(
                    radius: screenWidth * 0.08,
                    backgroundImage:
                        vendors[index].profileImage != null
                            ? NetworkImage(
                              Urls.serviceProviderbaseUrl +
                                  vendors[index].profileImage!,
                            )
                            : const AssetImage(MyAssetsImage.brokenImage)
                                as ImageProvider,
                  ),
                ),
              ],
            ),

            // اسم البزنس
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.05,
                screenWidth * 0.05,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  vendors[index].businessName,
                  style: TextStyle(
                    color: MyColors.black,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // النوع والتقييم
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.025,
                screenHeight * 0.01,
                screenWidth * 0.05,
                screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendors[index].type,
                    style: TextStyle(
                      color: MyColors.gray,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Row(
                    children: [
                      const Icon(Icons.star, color: MyColors.star),
                      SizedBox(width: screenWidth * 0.015),
                      Text(
                        vendors[index].rating.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: MyColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet<void>(
      backgroundColor: MyColors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: screenHeight * 0.6,
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      AppStrings.filterByCategory,
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Wrap(
                      spacing: screenWidth * 0.02,
                      runSpacing: screenHeight * 0.01,
                      children:
                          categories.keys.map((category) {
                            return FilterChip(
                              selectedColor: MyColors.primary,
                              shadowColor: MyColors.white,
                              disabledColor: MyColors.white,
                              backgroundColor: MyColors.white,
                              checkmarkColor: MyColors.white,
                              surfaceTintColor: MyColors.whiteSmoke,
                              label: Text(category),
                              selected: selectedCategories.contains(category),
                              onSelected: (selected) {
                                setModalState(() {
                                  if (selected) {
                                    selectedCategories.add(category);
                                  } else {
                                    selectedCategories.remove(category);
                                  }
                                });
                              },
                            );
                          }).toList(),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          MyColors.primary,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          MyColors.white,
                        ),
                        elevation: WidgetStateProperty.all(0),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ),
                            side: const BorderSide(color: MyColors.ghostColor),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                      ),
                      onPressed: () {
                        final selectedValues =
                            selectedCategories
                                .map((key) => categories[key]!)
                                .toList();

                        setState(() {
                          if (searchValue.isNotEmpty) {
                            searchAndFilterVendors(searchValue, selectedValues);
                          } else {
                            filterVendors(selectedValues);
                          }
                        });

                        Navigator.pop(context);
                      },
                      child: const Text(AppStrings.applyFilters),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void loadMoreData() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        pageNumber < totalPages &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });

      pageNumber++;

      switch (currentMode) {
        case VendorMode.normal:
          GetVendor().getAllVendors(pageNumber).then((fetchedItems) {
            setState(() {
              vendors.addAll(fetchedItems.items);
              totalPages = fetchedItems.totalPages;
              isLoading = false;
            });
          });
          break;

        case VendorMode.search:
          GetVendor().searchVendors(searchValue, pageNumber).then((
            fetchedItems,
          ) {
            setState(() {
              vendors.addAll(fetchedItems.items);
              totalPages = fetchedItems.totalPages;
              isLoading = false;
            });
          });
          break;

        case VendorMode.filter:
          GetVendor().filterVendors(filterValues, pageNumber).then((
            fetchedItems,
          ) {
            setState(() {
              vendors.addAll(fetchedItems.items);
              totalPages = fetchedItems.totalPages;
              isLoading = false;
            });
          });
          break;

        case VendorMode.searchfilter:
          GetVendor()
              .searchFilterVendors(filterValues, pageNumber, searchValue)
              .then((fetchedItems) {
                setState(() {
                  vendors.addAll(fetchedItems.items);
                  totalPages = fetchedItems.totalPages;
                  isLoading = false;
                });
              });
          break;
      }
    }
  }

  void searchVendors(String? value) {
    if (value != null) {
      final currentSearch = value;

      setState(() {
        currentMode = VendorMode.search;
        searchValue = currentSearch;
        isLoading = true;
        pageNumber = 1;
        vendors.clear();
      });

      GetVendor().searchVendors(currentSearch, pageNumber).then((fetchedItems) {
        if (currentSearch == searchValue && currentMode == VendorMode.search) {
          setState(() {
            vendors.addAll(fetchedItems.items);
            totalPages = fetchedItems.totalPages;
            isLoading = false;
          });
        }
      });
    }
  }

  void filterVendors(List<String>? businessTypes) {
    if (businessTypes != null) {
      setState(() {
        currentMode = VendorMode.filter;
        filterValues = businessTypes;
        isLoading = true;
        pageNumber = 1;
        vendors.clear();
      });

      GetVendor().filterVendors(businessTypes, pageNumber).then((fetchedItems) {
        setState(() {
          // vendors.clear();
          vendors.addAll(fetchedItems.items);
          totalPages = fetchedItems.totalPages;
          isLoading = false;
        });
      });
      //pageNumber++;
    }
  }

  void searchAndFilterVendors(String value, List<String> businessTypes) {
    final currentSearch = value;
    final currentFilters = List<String>.from(businessTypes);

    setState(() {
      currentMode = VendorMode.searchfilter;
      searchValue = currentSearch;
      filterValues = currentFilters;
      isLoading = true;
      pageNumber = 1;
      vendors.clear();
    });

    GetVendor()
        .searchFilterVendors(currentFilters, pageNumber, currentSearch)
        .then((fetchedItems) {
          if (currentSearch == searchValue &&
              currentFilters.toString() == filterValues.toString()) {
            setState(() {
              vendors.addAll(fetchedItems.items);
              totalPages = fetchedItems.totalPages;
              isLoading = false;
            });
          }
        });
  }
}

enum VendorMode { normal, search, filter, searchfilter }
