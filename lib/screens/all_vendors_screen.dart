// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/all_vendors.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class AllVendorsScreen extends StatefulWidget {
  @override
  _AllVendorsScreenState createState() => _AllVendorsScreenState();
}

class _AllVendorsScreenState extends State<AllVendorsScreen> {
  List<String> selectedCategories = [];
  List<String> categories = [
    "Technology",
    "Fashion",
    "Food",
    "Travel",
    "Sports",
    "Music",
    "Art",
    "Books",
  ];

  List<Provider> providers = [
    Provider("Urban Dining Co.", "Restaurant & Catering", 4.8, 150),
    Provider("Metro Shopping Mall", "Retail & Entertainment", 4.6, 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.oldLace,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Theme(
                data: Theme.of(context).copyWith(
                  searchBarTheme: SearchBarThemeData(
                    shadowColor: WidgetStateProperty.all(MyColors.oldLace),
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
                  onChanged: (query) {},
                  leading: const Icon(Icons.search, color: MyColors.black),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ), // Rounded corners
                  ),
                ),
              ),
            ),

            Expanded(
              child: FutureBuilder<AllVendor>(
                future: GetVendor().getAllVendors(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Items> vendors = snapshot.data!.items;
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: vendors.length,
                      itemBuilder: (context, index) {
                        // ignore: avoid_unnecessary_containers
                        return Card(
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
                                            rating: 2,
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
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showFilterModal(context),
              child: const Text("Filter"),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text(
                    "Filter by Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        categories.map((category) {
                          return FilterChip(
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filters"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Provider {
  final String name;
  final String category;
  final double rating;
  final int reviewCount;

  Provider(this.name, this.category, this.rating, this.reviewCount);
}
