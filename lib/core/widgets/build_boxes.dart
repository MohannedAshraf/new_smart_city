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
  final List<MostRequested> items;
  final String title;
  final double width;
  final double height;
  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumlines;

  const BuildBoxes({
    super.key,
    required this.title,
    required this.items,
    required this.destination,
    required this.fit,
    required this.height,
    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    required this.width,
    this.titlefontSize,
    this.maximumlines,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.02, // تقريبًا 8.w
            screenHeight * 0.012, // 10.h
            screenWidth * 0.04, // 15.w
            screenHeight * 0.012,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // تقريبًا 20.sp
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'عرض الجميع',
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: screenWidth * 0.03, // 12.sp
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const GovernmentServices(),
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
                            (_) =>
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
                      'يستغرق استخراجه ${items[index].time} بتكلفة ${items[index].fee} جنيهًا فقط لا غير',
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
        SizedBox(height: screenHeight * 0.025), // تقريبًا 20.h
      ],
    );
  }
}

class BuildProductsBoxes extends StatelessWidget {
  final List<MostRequestedProduct> items;
  final String title;
  final double width;
  final double height;
  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumLines;

  const BuildProductsBoxes({
    super.key,
    required this.title,
    required this.items,
    required this.destination,
    required this.fit,
    required this.height,
    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    required this.width,
    this.titlefontSize,
    this.maximumLines,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.02,
            screenHeight * 0.012,
            screenWidth * 0.02,
            screenHeight * 0.012,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // تقريبًا 20.sp
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'عرض الجميع',
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: screenWidth * 0.03, // تقريبًا 12.sp
                      ),
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => const HomePage(initialIndex: 3),
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
                            (_) =>
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
        SizedBox(height: screenHeight * 0.02), // تقريبًا 20.h
      ],
    );
  }
}

class BuildVendorssBoxes extends StatelessWidget {
  final List<Vendor> items;
  final String title;
  final double width;
  final double height;
  final double imageHeight;
  final double imageWidth;
  final BoxFit fit;
  final EdgeInsetsGeometry imagePadding;
  final Widget destination;
  final double? titlefontSize;
  final int? maximumLines;

  const BuildVendorssBoxes({
    super.key,
    required this.title,
    required this.items,
    required this.destination,
    required this.fit,
    required this.height,
    required this.imageHeight,
    required this.imagePadding,
    required this.imageWidth,
    required this.width,
    this.titlefontSize,
    this.maximumLines,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.02, // يعادل تقريبًا 8.w
            screenHeight * 0.012, // تقريبًا 10.h
            screenWidth * 0.02,
            screenHeight * 0.012,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth * 0.05, // تقريبًا 20.sp
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'عرض الجميع',
                      style: TextStyle(
                        color: MyColors.primary,
                        fontSize: screenWidth * 0.03, // تقريبًا 12.sp
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
        SizedBox(
          height: height,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final vendor = items[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VendorProfile(id: vendor.id),
                    ),
                  );
                },
                child: ServiceBox(
                  title: vendor.businessName,
                  width: width,
                  details: '${vendor.name}\n${vendor.type}',
                  image: Urls.serviceProviderbaseUrl + vendor.image!,
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
        SizedBox(height: screenHeight * 0.02), // تقريبًا 20.h
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      margin: EdgeInsets.fromLTRB(
        screenWidth * 0.01, // تقريبًا 4.w
        screenHeight * 0.005, // تقريبًا 2.h
        screenWidth * 0.01,
        screenHeight * 0.005,
      ),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: const [
          BoxShadow(
            color: MyColors.whiteSmoke,
            blurRadius: 4.0,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(screenWidth * 0.053),
              topRight: Radius.circular(screenWidth * 0.053),
            ),
            child: Padding(
              padding: imagePadding,
              child: Row(
                children:
                    imageIcon != null
                        ? [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.white,
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.04,
                              ),
                            ),
                            width: imageWidth,
                            height: imageHeight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                screenWidth * 0.053,
                              ),
                              child: imageIcon,
                            ),
                          ),
                        ]
                        : [
                          Image.network(
                            image!,
                            width: imageWidth,
                            height: imageHeight,
                            fit: fit,
                            errorBuilder:
                                (_, __, ___) => SizedBox(
                                  width: imageWidth,
                                  height: imageHeight,
                                  child: const Image(
                                    image: AssetImage(
                                      MyAssetsImage.brokenImage,
                                    ),
                                  ),
                                ),
                          ),
                        ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.03,
              screenHeight * 0.01,
              screenWidth * 0.03,
              screenHeight * 0.005,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: titlefontSize ?? screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.03,
              screenHeight * 0.005,
              screenWidth * 0.03,
              screenHeight * 0.01,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    details,
                    maxLines: maximumlines ?? 2,
                    style: TextStyle(
                      color: MyColors.gray,
                      fontSize: screenWidth * 0.03,
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
