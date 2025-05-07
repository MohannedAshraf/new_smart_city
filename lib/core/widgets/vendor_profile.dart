import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/utils/mycolors.dart';
import 'package:city/models/all_vendors.dart';
import 'package:city/services/get_vendor.dart';
import 'package:flutter/material.dart';

class VendorProfile extends StatelessWidget {
  // final String uderId;

  const VendorProfile({super.key /*required this.uderId*/});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.oldLace,
      body: FutureBuilder<AllVendor>(
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
                  child: Container(
                    // width: double.infinity,
                    height: 200,
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(13),
                                topRight: Radius.circular(13),
                              ),
                              child: Image.network(
                                vendors[index].coverImage,
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
                                        MyAssetsImage.brokenImage,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              top: 45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 8, 20, 0),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: NetworkImage(
                                        vendors[index].profileImage,
                                        // vendors[index].profileImage,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 45, 20, 8),
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
    );
  }
}
