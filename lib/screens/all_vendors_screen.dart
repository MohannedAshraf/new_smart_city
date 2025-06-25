// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'package:citio/core/utils/assets_image.dart';

import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/all_vendors.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:citio/screens/vendor_profile.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        // foregroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Text(
            'المتاجر والخدمات',
            style: TextStyle(color: MyColors.black, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.offWhite,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 6, 16),
                      child: IconButton(
                        onPressed:
                            () => setState(() {
                              _showFilterModal(context);
                            }),
                        icon: const Icon(
                          Icons.tune,
                          color: MyColors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 5, 10),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            hoverColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            searchBarTheme: SearchBarThemeData(
                              shadowColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                MyColors.white,
                              ),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle(color: MyColors.black),
                              ),
                            ),
                          ),
                          child: SearchBar(
                            hintText: "ابحث عن بائع أو خدمة",
                            hintStyle: WidgetStateProperty.all(
                              const TextStyle(color: MyColors.gray),
                            ),

                            leading: const Icon(
                              Icons.search,
                              color: MyColors.gray,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ), // Rounded corners
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
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: false,
                scrollDirection: Axis.vertical,
                controller: scrollController,
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  // ignore: avoid_unnecessary_containers
                  return GestureDetector(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    VendorProfile(id: vendors[index].id),
                          ),
                        ),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      children: [
                        vendorCard(index),
                        if (index == vendors.length - 1 && isLoading)
                          const Padding(
                            padding: EdgeInsets.all(10),
                            child: SpinKitFadingCircle(
                              color: MyColors.mintgreen,
                              size: 40,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // 👈 هنا بتتحكم في ال radius
      ),
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: SizedBox(
        width: screenWidth * .9,
        height: screenHeight * 0.37,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              //alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child:
                      vendors[index].coverImage != null
                          ? Image.network(
                            Urls.serviceProviderbaseUrl +
                                vendors[index].coverImage!,
                            // vendors[index].coverImage,
                            width: double.infinity,
                            height: screenHeight * 0.165,
                            fit: BoxFit.cover,
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return SizedBox(
                                height: screenHeight * 0.165,
                                width: double.infinity,
                                child: const Image(
                                  image: AssetImage(MyAssetsImage.brokenImage),
                                ),
                              );
                            },
                          )
                          : Image.asset(
                            width: double.infinity,
                            height: screenHeight * 0.165,
                            MyAssetsImage.brokenImage,
                          ),
                ),
                Positioned(
                  top: screenHeight * 0.11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 20, 20),
                        child: CircleAvatar(
                          radius: 32,

                          backgroundImage:
                              vendors[index].profileImage != null
                                  ? NetworkImage(
                                    Urls.serviceProviderbaseUrl +
                                        vendors[index].profileImage!,
                                    // vendors[index].profileImage,
                                  )
                                  : const AssetImage(MyAssetsImage.brokenImage),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                  child: Text(
                    vendors[index].businessName,
                    style: const TextStyle(
                      color: MyColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 20, 0),
                        child: Text(
                          vendors[index].type,
                          style: const TextStyle(
                            color: MyColors.gray,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 20, 15),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: MyColors.star),
                            const SizedBox(width: 6),
                            Text(vendors[index].rating.toStringAsFixed(2)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: MyColors.white,

      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Filter by Category",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          categories.keys.map((category) {
                            return FilterChip(
                              selectedColor: MyColors.dodgerBlue,
                              shadowColor: MyColors.white,
                              disabledColor: MyColors.white,
                              backgroundColor: MyColors.white,
                              checkmarkColor: MyColors.white,
                              surfaceTintColor: MyColors.whiteSmoke,
                              label: Text(category),
                              selected: selectedCategories.contains(category),
                              onSelected: (selected) {
                                setState(() {
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          MyColors.dodgerBlue,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          MyColors.white,
                        ),
                        elevation: WidgetStateProperty.all(0),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: MyColors.ghostColor),
                          ),
                        ),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                      onPressed: () {
                        List<String> selectedValues =
                            selectedCategories
                                .map((key) => categories[key]!)
                                .toList();

                        setState(() {
                          //filterVendors(selectedValues);
                          if (searchValue.isNotEmpty) {
                            searchAndFilterVendors(searchValue, selectedValues);
                          } else {
                            filterVendors(selectedValues);
                          }
                        });
                        Navigator.pop(context);
                      },
                      child: const Text("Apply Filters"),
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
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        pageNumber < totalPages &&
        !isLoading) {
      setState(() {
        isLoading = true;
      });

      pageNumber++;

      //  Future.delayed(const Duration(seconds: 0), () {
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
      //});
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
