// ignore_for_file: unused_element, avoid_unnecessary_containers, library_private_types_in_public_api, prefer_const_constructors

import 'package:citio/core/utils/assets_image.dart';

import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/category_tab_view.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorProfile extends StatefulWidget {
  final String id;
  const VendorProfile({super.key, required this.id});

  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.white,
        // foregroundColor: MyColors.white,
        surfaceTintColor: MyColors.white,
        title: Padding(
          padding: EdgeInsets.fromLTRB(
            0.w,
            MediaQuery.of(context).size.height * 0.015,
            0.w,
            MediaQuery.of(context).size.height * 0.015,
          ),
          child: Text(
            'تفاصيل الخدمة',
            style: TextStyle(
              color: MyColors.black,
              fontSize: MediaQuery.of(context).size.height * 0.025,
            ),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.offWhite,
      body: Padding(
        padding: EdgeInsets.fromLTRB(
          0.w,
          MediaQuery.of(context).size.height * 0.00875,
          0.w,
          0.h,
        ),
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
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01875,
                    ),
                    Container(
                      color: MyColors.white,
                      child: Transform.translate(
                        offset: Offset(screenWidth * .12, 0),
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
      margin: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.height * 0.0125,
        MediaQuery.of(context).size.width * 0.05,
        MediaQuery.of(context).size.height * 0.00375,
      ),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      MediaQuery.of(context).size.width * 0.05,
                    ),
                    topRight: Radius.circular(
                      MediaQuery.of(context).size.width * 0.05,
                    ),
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
                        padding: EdgeInsets.fromLTRB(
                          0.w,
                          MediaQuery.of(context).size.height * 0.01,
                          MediaQuery.of(context).size.width * 0.05,
                          MediaQuery.of(context).size.height * 0.0250,
                        ),
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.08,

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
                  padding: EdgeInsets.fromLTRB(
                    0.w,
                    MediaQuery.of(context).size.height * 0.05,
                    MediaQuery.of(context).size.width * 0.05,
                    0.h,
                  ),
                  child: Text(
                    vendor.businessName,
                    style: TextStyle(
                      color: MyColors.black,
                      fontSize: MediaQuery.of(context).size.height * 0.02250,
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
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.025,
                          MediaQuery.of(context).size.height * 0.00625,
                          MediaQuery.of(context).size.width * 0.05,
                          0.h,
                        ),
                        child: Text(
                          vendor.type,
                          style: TextStyle(
                            color: MyColors.gray,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.0175,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.025,
                          MediaQuery.of(context).size.height * 0.0125,
                          MediaQuery.of(context).size.width * 0.05,
                          MediaQuery.of(context).size.height * 0.01875,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: MyColors.star),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015,
                            ),
                            Text(vendor.rating.toStringAsFixed(2)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015,
                            ),
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
