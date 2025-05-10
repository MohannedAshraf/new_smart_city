import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class CategoryTabView extends StatelessWidget {
  final String vendorId;
  final int categoryId;

  const CategoryTabView({required this.categoryId, required this.vendorId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VendorSubcategoryProducts>>(
      future: GetVendor().getVendorSubcategoryProducts(vendorId, categoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<VendorSubcategoryProducts> products = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: products.length,
            itemBuilder: (context, index) {
              // ignore: avoid_unnecessary_containers
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: MyColors.white,
                    shadowColor: MyColors.whiteSmoke,
                    elevation: 3,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      width: 80,
                                      height: 80,

                                      _baseUrl + products[index].image!,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        BuildContext context,
                                        Object error,
                                        StackTrace? stackTrace,
                                      ) {
                                        return const SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image(
                                            image: AssetImage(
                                              MyAssetsImage.brokenImage,
                                            ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            8,
                                            8,
                                            8,
                                            10,
                                          ),
                                          child: Text(
                                            products[index].name,
                                            style: const TextStyle(
                                              color: MyAppColors.black,
                                              fontSize: 14,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            8,
                                            8,
                                            8,
                                            10,
                                          ),
                                          child: Text(
                                            '${products[index].price}LE',
                                            style: const TextStyle(
                                              color: MyAppColors.black,
                                              fontSize: 12,
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
                                      padding: const EdgeInsets.fromLTRB(
                                        8,
                                        0,
                                        8,
                                        10,
                                      ),
                                      child: Text(
                                        products[index].description!,
                                        maxLines: 6,
                                        softWrap: true,

                                        style: const TextStyle(
                                          color: MyAppColors.black,
                                          fontSize: 13,
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
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
