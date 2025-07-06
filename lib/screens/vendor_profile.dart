// ignore_for_file: library_private_types_in_public_api

import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
          child: Text(
            AppStrings.serviceDetails,
            style: TextStyle(
              color: MyColors.black,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.01),
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
                          return vendorCard(snapshot.data!, screenWidth, screenHeight);
                        } else {
                          return SizedBox(
                            height: screenHeight * 0.35,
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Container(
                      color: MyColors.white,
                      child: Transform.translate(
                        offset: Offset(screenWidth * 0.12, 0),
                        child: TabBar(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.all(Colors.white),
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: MyColors.white,
                          indicatorColor: MyColors.primary,
                          labelColor: MyColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                          tabs: sub.map((i) => Tab(text: i.name)).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: sub.map((i) {
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

  Card vendorCard(Vendor vendor, double screenWidth, double screenHeight) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.015,
      ),
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.37,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: vendor.coverImage != null
                      ? Image.network(
                          Urls.serviceProviderbaseUrl + vendor.coverImage!,
                          width: double.infinity,
                          height: screenHeight * 0.165,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return SizedBox(
                              height: screenHeight * 0.165,
                              width: double.infinity,
                              child: const Image(image: AssetImage(MyAssetsImage.brokenImage)),
                            );
                          },
                        )
                      : Image.asset(
                          MyAssetsImage.brokenImage,
                          width: double.infinity,
                          height: screenHeight * 0.165,
                        ),
                ),
                Positioned(
                  top: screenHeight * 0.11,
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: CircleAvatar(
                      radius: screenWidth * 0.085,
                      backgroundImage: vendor.image != null
                          ? NetworkImage(Urls.serviceProviderbaseUrl + vendor.image!)
                          : const AssetImage(MyAssetsImage.brokenImage) as ImageProvider,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.05, left: screenWidth * 0.05),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  vendor.businessName,
                  style: TextStyle(
                    color: MyColors.black,
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005, left: screenWidth * 0.05),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  vendor.type,
                  style: TextStyle(
                    color: MyColors.gray,
                    fontSize: screenWidth * 0.037,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.05),
              child: Row(
                children: [
                  const Icon(Icons.star, color: MyColors.star),
                  SizedBox(width: screenWidth * 0.02),
                  Text(vendor.rating.toStringAsFixed(2)),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    '(${vendor.numOfReviews} ${AppStrings.ratings})',
                    style: const TextStyle(color: MyColors.gray),
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
