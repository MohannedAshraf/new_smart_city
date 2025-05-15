// ignore_for_file: unused_element, avoid_unnecessary_containers

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/category_tab_view.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class VendorProfile extends StatelessWidget {
  final String id;
  const VendorProfile({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VendorSubcategory>>(
      future: GetVendor().getVendorSubcategory(id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<VendorSubcategory> sub = snapshot.data!;
          return DefaultTabController(
            length: sub.length,
            child: Scaffold(
              body: Column(
                children: [
                  FutureBuilder<Vendor>(
                    future: GetVendor().getVendorById(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Vendor vendor = snapshot.data!;
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              // borderRadius: BorderRadius.circular(20),
                              child: Container(
                                // Adjust radius as needed
                                // Optional: Add background color
                                child:
                                    vendor.coverImage != null
                                        ? Image.network(
                                          _baseUrl + vendor.coverImage!,
                                          width: double.infinity,
                                          height: 220,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            BuildContext context,
                                            Object error,
                                            StackTrace? stackTrace,
                                          ) {
                                            return const SizedBox(
                                              height: 220,
                                              width: double.infinity,
                                              child: Image(
                                                image: AssetImage(
                                                  MyAssetsImage.brokenImage,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                        : Image.asset(
                                          width: double.infinity,
                                          height: 220,
                                          MyAssetsImage.brokenImage,
                                        ),
                              ),
                            ),
                            Positioned(
                              top: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Card(
                                  color: MyColors.white,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      7,
                                      12,
                                      12,
                                      7,
                                    ),
                                    width: 320,
                                    height: 190,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Card(
                                                  elevation: 5,
                                                  shadowColor:
                                                      MyColors.whiteSmoke,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          40,
                                                        ),
                                                  ),
                                                  color: Colors.transparent,
                                                  child: CircleAvatar(
                                                    radius: 40,
                                                    backgroundImage: NetworkImage(
                                                      vendor.image ??
                                                          'https://cdn-icons-png.flaticon.com/128/11820/11820229.png',
                                                    ),
                                                    /*_user.avatar != null
                                                          ? NetworkImage(_user.avatar!)
                                                          : null,*/
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    2,
                                                                    12,
                                                                    12,
                                                                    0,
                                                                  ),
                                                              child: Text(
                                                                vendor
                                                                    .businessName,
                                                                style: const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      MyColors
                                                                          .black,
                                                                ),
                                                                maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets.fromLTRB(
                                                                    2,
                                                                    12,
                                                                    12,
                                                                    0,
                                                                  ),
                                                              child: Text(
                                                                'تقييم 5.0',
                                                                style: TextStyle(
                                                                  fontSize: 16,

                                                                  color:
                                                                      Colors
                                                                          .orangeAccent,
                                                                ),
                                                              ),
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    2,
                                                                    15,
                                                                    12,
                                                                    0,
                                                                  ),
                                                              child: Text(
                                                                vendor.type,
                                                                style: const TextStyle(
                                                                  fontSize: 12,

                                                                  color:
                                                                      MyColors
                                                                          .gray,
                                                                ),
                                                                //maxLines: 2,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.fromLTRB(
                                                                    2,
                                                                    15,
                                                                    4,
                                                                    0,
                                                                  ),
                                                              child: StarRating(
                                                                size: 20.0,
                                                                rating:
                                                                    vendor
                                                                        .rating,
                                                                color:
                                                                    Colors
                                                                        .orange,
                                                                borderColor:
                                                                    Colors.grey,
                                                                allowHalfRating:
                                                                    true,
                                                                starCount: 5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Row(children: []),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox(
                          height: 280,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  TabBar(
                    isScrollable: true,
                    indicatorColor: MyColors.black,
                    labelColor: MyColors.black,
                    unselectedLabelColor: MyColors.gray,

                    tabs: sub.map((i) => Tab(text: i.name)).toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      children:
                          sub.map((i) {
                            return CategoryTabView(
                              categoryId: i.id,
                              vendorId: id,
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
