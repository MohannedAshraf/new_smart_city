import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/vendor_subcategory.dart';
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
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h),
                  child: productCard(context, products, index),
                );
              },
            );
          } else {
            return emptyCategory(context);
          }
        } else {
          return emptyCategory(context);
        }
      },
    );
  }

  Center emptyCategory(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // علشان تتوسّط الشاشة
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MyColors.white,
            radius: MediaQuery.of(context).size.width * 0.1125,
            child: Icon(
              Icons.inventory,
              color: MyColors.fadedGrey,
              size: MediaQuery.of(context).size.height * 0.05, // خليه أكبر شوية
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.0250,
          ), // مسافة بين الصورة والنص
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              'الخدمات غير متوفرة',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: MyAppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0125),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Text(
              'الخدمات في هذه الفئة غير متوفرة حاليا',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: MyAppColors.gray,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Card productCard(
    BuildContext context,
    List<VendorSubcategoryProducts> products,
    int index,
  ) {
    return Card(
      color: MyColors.white,
      shadowColor: MyColors.whiteSmoke,
      elevation: 0,
      child: Row(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.network(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.1,

                        _baseUrl + products[index].image!,
                        fit: BoxFit.contain,
                        errorBuilder: (
                          BuildContext context,
                          Object error,
                          StackTrace? stackTrace,
                        ) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
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
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.02,
                              MediaQuery.of(context).size.height * 0.01,
                              MediaQuery.of(context).size.width * 0.02,
                              MediaQuery.of(context).size.height * 0.0125,
                            ),
                            child: Text(
                              products[index].name,
                              style: TextStyle(
                                color: MyAppColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.0175,
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
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width * 0.02,
                              MediaQuery.of(context).size.height * 0.01,
                              MediaQuery.of(context).size.width * 0.02,
                              MediaQuery.of(context).size.height * 0.0125,
                            ),
                            child: Text(
                              '${products[index].price}LE',
                              style: TextStyle(
                                color: MyAppColors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
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
                        padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.02,
                          0.h,
                          MediaQuery.of(context).size.width * 0.02,
                          MediaQuery.of(context).size.height * 0.0125,
                        ),
                        child: Text(
                          products[index].description!,
                          maxLines: 6,
                          softWrap: true,

                          style: TextStyle(
                            color: MyAppColors.black,
                            fontSize:
                                MediaQuery.of(context).size.height * 0.01625,
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
