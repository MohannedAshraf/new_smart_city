// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/main.dart';
import 'package:citio/models/most_requested_services.dart';

import 'package:citio/core/utils/assets_image.dart';

import 'package:citio/models/most_requested_products.dart';

import 'package:citio/models/vendor.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:citio/screens/government_services.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/vendor_profile.dart';
import 'package:citio/services/get_gov_service_image.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//String _baseUrl = 'https://service-provider.runasp.net';
// ignore: must_be_immutable
Map<String, String> iconsGov = {
  "إصدار جواز سفر": 'https://cdn-icons-png.flaticon.com/128/4774/4774004.png',
  "رخصة قيادة": 'https://cdn-icons-png.flaticon.com/128/18395/18395873.png',
  "شهادة ميلاد": 'https://cdn-icons-png.flaticon.com/128/14236/14236286.png',
  "شهادة زواج": 'https://cdn-icons-png.flaticon.com/128/9835/9835447.png',
  "تأمين صحي": 'https://cdn-icons-png.flaticon.com/128/6512/6512351.png',
  "تسجيل ضريبي": 'https://cdn-icons-png.flaticon.com/128/12692/12692536.png',
  "رخصة تجارية": 'https://cdn-icons-png.flaticon.com/128/1728/1728507.png',
};
Map<int, Uint8List?> imageCache = {};

class BuildBoxes extends StatelessWidget {
  //BuildContext context;
  final List<MostRequested> items;
  final String title;
  final double width;
  // final String details;
  final double height;

  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  // final int itemCount;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumlines;

  const BuildBoxes({
    super.key,
    required this.title,
    required this.items,
    // required this.details,
    required this.destination,
    required this.fit,
    required this.height,

    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    //  required this.itemCount,
    required this.width,
    this.titlefontSize,
    this.maximumlines,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.h, 15.w, 10.h),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'عرض الجميع',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12.sp,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => const GovernmentServices(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                GovernmentServiceDetails(id: items[index].id),
                      ),
                    ),
                child: ServiceBox(
                  imageIcon:
                      imageCache[items[index].id] != null
                          ? Image.memory(
                            imageCache[items[index].id]!,
                            fit: BoxFit.cover,
                            height: imageHeight,
                            width: imageWidth,
                          )
                          : FutureBuilder<Uint8List?>(
                            future: ServiceImage().getImage(
                              id: items[index].id,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                  width: imageWidth,
                                  height: imageHeight,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (snapshot.hasData) {
                                imageCache[items[index].id] = snapshot.data!;
                                return Image.memory(snapshot.data!);
                              }

                              return const Icon(Icons.broken_image);
                            },
                          ),
                  iconColor:
                      Styles.govTabStyles[items[index]
                          .category]?['fontColor'] ??
                      MyColors.black,
                  backgroundColor:
                      Styles.govTabStyles[items[index].category]?['color'] ??
                      MyColors.whiteSmoke,
                  title: items[index].serviceName,
                  width: width,
                  details:
                      'يستغرق استخراجه ${items[index].time} بتكلفة  ${items[index].fee} جنيهًا فقط لا غير',

                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                  fit: fit,
                  imagePadding: imagePadding,
                  maximumlines: maximumlines,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.0.h),
      ],
    );
  }
}

class BuildProductsBoxes extends StatelessWidget {
  //BuildContext context;
  final List<MostRequestedProduct> items;
  final String title;
  final double width;
  //final String details;
  final double height;

  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  // final int itemCount;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumLines;
  const BuildProductsBoxes({
    super.key,
    required this.title,
    required this.items,
    // required this.details,
    required this.destination,
    required this.fit,
    required this.height,

    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    //  required this.itemCount,
    required this.width,
    this.titlefontSize,
    this.maximumLines,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'عرض الجميع',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12.sp,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const HomePage(initialIndex: 3),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ProductDetailsView(productId: items[index].id),
                      ),
                    ),
                child: ServiceBox(
                  title: items[index].name,
                  width: width,
                  details: items[index].discription,
                  image: Urls.serviceProviderbaseUrl + items[index].image!,
                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                  fit: fit,
                  imagePadding: imagePadding,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.0.h),
      ],
    );
  }
}

class BuildVendorssBoxes extends StatelessWidget {
  //BuildContext context;
  final List<Vendor> items;
  final String title;
  final double width;
  //final String details;
  final double height;

  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  // final int itemCount;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumLines;
  const BuildVendorssBoxes({
    super.key,
    required this.title,
    required this.items,
    // required this.details,
    required this.destination,
    required this.fit,
    required this.height,

    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    //  required this.itemCount,
    required this.width,
    this.titlefontSize,
    this.maximumLines,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8.w, 10.h, 8.w, 10.h),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'عرض الجميع',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12.sp,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => destination,
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => VendorProfile(id: items[index].id),
                      ),
                    ),
                child: ServiceBox(
                  title: items[index].businessName,
                  width: width,
                  details: '${items[index].name}\n${items[index].type}',
                  image: Urls.serviceProviderbaseUrl + items[index].image!,
                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                  fit: fit,
                  imagePadding: imagePadding,
                  maximumlines: maximumLines,
                ),
              );
            },
          ),
        ),
        SizedBox(height: 20.0.h),
      ],
    );
  }
}

class ServiceBox extends StatelessWidget {
  final String title;
  final String details;
  final double width;
  final String? image;
  final double imageHeight;
  final double imageWidth;
  final BoxFit? fit;
  final EdgeInsetsGeometry imagePadding;
  final double? titlefontSize;
  final int? maximumlines;
  final Widget? imageIcon;
  final Color? iconColor;
  final Color? backgroundColor;
  const ServiceBox({
    super.key,
    required this.title,
    required this.width,
    required this.details,
    this.image,
    required this.imageHeight,
    required this.imageWidth,
    required this.imagePadding,
    this.fit,
    this.titlefontSize,
    this.maximumlines,
    this.imageIcon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12.0.r),
        boxShadow: const [
          BoxShadow(
            color: MyColors.whiteSmoke,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
            child: Padding(
              padding: imagePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:
                    imageIcon != null
                        ? [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.whiteSmoke,
                              borderRadius: BorderRadius.circular(15.r),
                            ),

                            width: imageWidth,
                            height: imageHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: imageIcon,
                            ),
                          ),
                        ]
                        : [
                          Image.network(
                            width: imageWidth,
                            height: imageHeight,
                            image!,
                            fit: fit,
                            errorBuilder: (
                              BuildContext context,
                              Object error,
                              StackTrace? stackTrace,
                            ) {
                              return SizedBox(
                                height: imageHeight,
                                width: imageWidth,
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
          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 4.h, 10.w, 2.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: 1,
                    title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: titlefontSize ?? 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    //maxLines: 2,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 10.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: maximumlines ?? 2,
                    details,
                    style: TextStyle(
                      color: const Color.fromARGB(221, 59, 58, 58),
                      fontSize: 12.0.sp,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
