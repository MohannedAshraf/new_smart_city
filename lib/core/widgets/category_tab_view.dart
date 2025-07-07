import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';

String _baseUrl = Urls.serviceProviderbaseUrl;

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
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<VendorSubcategoryProducts> products = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                ),
                child: productCard(products, index, context),
              );
            },
          );
        } else {
          return emptyCategory(context);
        }
      },
    );
  }

  Center emptyCategory(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: MyColors.white,
            radius: width * 0.12,
            child: Icon(
              Icons.inventory,
              color: const Color.fromARGB(26, 49, 7, 7),
              size: width * 0.1,
            ),
          ),
          SizedBox(height: height * 0.03),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Text(
              AppStrings.noServices,
              style: TextStyle(fontSize: width * 0.045, color: MyColors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: height * 0.015),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Text(
              AppStrings.noServicesInCategory,
              style: TextStyle(fontSize: width * 0.04, color: MyColors.gray),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector productCard(
    List<VendorSubcategoryProducts> products,
    int index,
    BuildContext context,
  ) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsView(productId: products[index].id),
          ),
        );
      },
      child: Card(
        color: MyColors.white,
        shadowColor: MyColors.whiteSmoke,
        elevation: 0.5,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(width * 0.05),
                child: Image.network(
                  _baseUrl + products[index].image!,
                  width: width * 0.22,
                  height: height * 0.12,
                  fit: BoxFit.contain,
                  errorBuilder:
                      (context, error, stackTrace) => SizedBox(
                        width: width * 0.22,
                        height: height * 0.12,
                        child: const Image(
                          image: AssetImage(MyAssetsImage.brokenImage),
                        ),
                      ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      products[index].name,
                      style: TextStyle(
                        color: MyColors.black,
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      '${products[index].price} LE',
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      products[index].description ?? '',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.034,
                        color: MyColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
