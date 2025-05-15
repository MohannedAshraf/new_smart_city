// ignore_for_file: library_private_types_in_public_api

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/all_vendors.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:citio/screens/vendor_profile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String _baseUrl = 'https://service-provider.runasp.net';

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
    return Scaffold(
      backgroundColor: MyColors.oldLace,
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
                        padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            searchBarTheme: SearchBarThemeData(
                              shadowColor: WidgetStateProperty.all(
                                MyColors.oldLace,
                              ),
                              backgroundColor: WidgetStateProperty.all(
                                MyColors.whiteSmoke,
                              ),
                              textStyle: WidgetStateProperty.all(
                                const TextStyle(color: MyColors.black),
                              ),
                            ),
                          ),
                          child: SearchBar(
                            hintText: "Search providers...",

                            leading: const Icon(
                              Icons.search,
                              color: MyColors.black,
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ), // Rounded corners
                            ),
                            onSubmitted: (value) {
                              searchVendors(value);
                              isSearching = true;
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
                        Card(
                          color: MyColors.white,
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: SizedBox(
                            // width: double.infinity,
                            height: 200,
                            child: Column(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  //alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13),
                                      ),
                                      child:
                                          vendors[index].coverImage != null
                                              ? Image.network(
                                                _baseUrl +
                                                    vendors[index].coverImage!,
                                                // vendors[index].coverImage,
                                                width: double.infinity,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (
                                                  BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  return const SizedBox(
                                                    height: 120,
                                                    width: double.infinity,
                                                    child: Image(
                                                      image: AssetImage(
                                                        MyAssetsImage
                                                            .brokenImage,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                              : Image.asset(
                                                width: double.infinity,
                                                height: 120,
                                                MyAssetsImage.brokenImage,
                                              ),
                                    ),
                                    Positioned(
                                      top: 45,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              8,
                                              20,
                                              0,
                                            ),
                                            child: CircleAvatar(
                                              radius: 40,

                                              backgroundImage:
                                                  vendors[index].profileImage !=
                                                          null
                                                      ? NetworkImage(
                                                        _baseUrl +
                                                            vendors[index]
                                                                .profileImage!,
                                                        // vendors[index].profileImage,
                                                      )
                                                      : const AssetImage(
                                                        MyAssetsImage
                                                            .brokenImage,
                                                      ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                      0,
                                                      5,
                                                      20,
                                                      10,
                                                    ),
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              10,
                                              45,
                                              20,
                                              8,
                                            ),
                                            child: Text(
                                              vendors[index].type,
                                              style: const TextStyle(
                                                color: MyColors.gray,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            10,
                                            45,
                                            20,
                                            8,
                                          ),
                                          child: StarRating(
                                            size: 20.0,
                                            rating: vendors[index].rating,
                                            color: Colors.orange,
                                            borderColor: Colors.grey,
                                            allowHalfRating: true,
                                            starCount: 5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
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

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: MyColors.white,

      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.5,
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
                              selectedColor: MyColors.cardcolor,
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
                          MyColors.cardcolor,
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          MyColors.black,
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
                          filterVendors(selectedValues);
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

      Future.delayed(const Duration(seconds: 1), () {
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
        }
      });
    }
  }

  void searchVendors(String? value) {
    if (value != null) {
      setState(() {
        currentMode = VendorMode.search;
        searchValue = value;
        isLoading = true;
        pageNumber = 1;
        vendors.clear();
      });

      GetVendor().searchVendors(searchValue, pageNumber).then((fetchedItems) {
        setState(() {
          // vendors.clear();
          vendors.addAll(fetchedItems.items);
          totalPages = fetchedItems.totalPages;
          isLoading = false;
        });
      });
      // pageNumber++;
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
}

enum VendorMode { normal, search, filter }
