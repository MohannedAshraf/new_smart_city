// ignore_for_file: unused_element, avoid_unnecessary_containers, library_private_types_in_public_api, prefer_const_constructors

import 'package:citio/core/utils/assets_image.dart';

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/category_tab_view.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';

class VendorProfile extends StatefulWidget {
  final String id;
  const VendorProfile({super.key, required this.id});

  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        // foregroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
          child: Text(
            'تفاصيل الخدمة',
            style: TextStyle(color: MyColors.black, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.offWhite,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
        child: FutureBuilder<List<VendorSubcategory>>(
          future: GetVendor().getVendorSubcategory(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<VendorSubcategory> sub = snapshot.data!;
              return DefaultTabController(
                length: sub.length,
                child: Column(
                  children: [
                    FutureBuilder<Vendor>(
                      future: GetVendor().getVendorById(widget.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          Vendor vendor = snapshot.data!;
                          return vendorCard(vendor);
                        } else {
                          return const SizedBox(
                            height: 280,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    Container(
                      color: MyColors.white,
                      child: TabBar(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: WidgetStateProperty.all(Colors.white),
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        dividerColor: MyColors.white,
                        indicatorColor: MyColors.inProgress,
                        labelColor: MyColors.inProgress,

                        tabs: sub.map((i) => Tab(text: i.name)).toList(),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children:
                            sub.map((i) {
                              return CategoryTabView(
                                categoryId: i.id,
                                vendorId: widget.id,
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Card vendorCard(Vendor vendor) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 3),
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
                      vendor.coverImage != null
                          ? Image.network(
                            Urls.serviceProviderbaseUrl + vendor.coverImage!,
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
                              vendor.image != null
                                  ? NetworkImage(
                                    Urls.serviceProviderbaseUrl + vendor.image!,
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
                    vendor.businessName,
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
                          vendor.type,
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
                            Text(vendor.rating.toStringAsFixed(2)),
                            const SizedBox(width: 6),
                            Text(
                              '(${vendor.rating.toString()} تقييما)',
                              style: TextStyle(color: MyColors.gray),
                            ),
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
}
