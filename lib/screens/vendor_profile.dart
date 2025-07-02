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
          padding: EdgeInsets.fromLTRB(0.w, 12.h, 0.w, 12.h),
          child: Text(
            'تفاصيل الخدمة',
            style: TextStyle(color: MyColors.black, fontSize: 20.sp),
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.offWhite,
      body: Padding(
        padding: EdgeInsets.fromLTRB(0.w, 7.h, 0.w, 0.h),
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
                            height: 280.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 15.h),
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
      margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 3.h),
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
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
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
                        padding: EdgeInsets.fromLTRB(0.w, 8.h, 20.w, 20.h),
                        child: CircleAvatar(
                          radius: 32.r,

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
                  padding: EdgeInsets.fromLTRB(0.w, 40.h, 20.w, 0.h),
                  child: Text(
                    vendor.businessName,
                    style: TextStyle(
                      color: MyColors.black,
                      fontSize: 18.sp,
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
                        padding: EdgeInsets.fromLTRB(10.w, 5.h, 20.w, 0.h),
                        child: Text(
                          vendor.type,
                          style: TextStyle(
                            color: MyColors.gray,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.h, 20.w, 15.h),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: MyColors.star),
                            SizedBox(width: 6.w),
                            Text(vendor.rating.toStringAsFixed(2)),
                            SizedBox(width: 6.w),
                            Text(
                              '(${vendor.numOfReviews.toString()} تقييما)',
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
