import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class CategoryTabView extends StatelessWidget {
  final String vendorId;
  final int categoryId;

  const CategoryTabView({
    super.key,
    required this.categoryId,
    required this.vendorId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VendorSubcategoryProducts>>(
      future: GetVendor().getVendorSubcategoryProducts(vendorId, categoryId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            List<VendorSubcategoryProducts> products = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8.r),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: productCard(products, index),
                );
              },
            );
          } else {
            return emptyCategory();
          }
        } else {
          return emptyCategory();
        }
      },
    );
  }

  Center emptyCategory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MyColors.white,
            radius: 45.r,
            child: Icon(
              Icons.inventory,
              color: MyColors.fadedGrey,
              size: 40.sp, // خليه أكبر شوية
            ),
          ),
          SizedBox(height: 20.h), // مسافة بين الصورة والنص
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'الخدمات غير متوفرة',
              style: TextStyle(fontSize: 16.sp, color: MyAppColors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'الخدمات في هذه الفئة غير متوفرة حاليا',
              style: TextStyle(fontSize: 16.sp, color: MyAppColors.gray),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Card productCard(List<VendorSubcategoryProducts> products, int index) {
    return Card(
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      elevation: 0,
      child: Row(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        width: 80.w,
                        height: 80.h,

                        _baseUrl + products[index].image!,
                        fit: BoxFit.contain,
                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return SizedBox(
                            height: 80.h,
                            width: 80.w,
                            child: const Image(
                              image: AssetImage(MyAssetsImage.brokenImage),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
                            child: Text(
                              products[index].name,
                              style: TextStyle(
                                color: MyAppColors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 10.h),
                            child: Text(
                              '${products[index].price}LE',
                              style: TextStyle(
                                color: MyAppColors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
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
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(8.w, 0.h, 8.w, 10.h),
                        child: Text(
                          products[index].description!,
                          maxLines: 6,
                          softWrap: true,

                          style: TextStyle(
                            color: MyAppColors.black,
                            fontSize: 13.sp,
                          ),
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
    );
  }
}
