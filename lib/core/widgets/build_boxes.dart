// ignore_for_file: deprecated_member_use

import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/most_requested_services.dart';

import 'package:citio/core/utils/assets_image.dart';

import 'package:citio/models/most_requested_products.dart';

import 'package:citio/models/vendor.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/vendor_profile.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

String _baseUrl = 'https://service-provider.runasp.net';
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
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
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
                            style: const TextStyle(
                              color: Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12,
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
        // const SizedBox(height: 10.0),
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
                  icon:
                      Styles.govTabStyles[items[index].category]?['icon'] ??
                      Icons.broken_image_rounded,
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
        const SizedBox(height: 20.0),
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
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
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
                            style: const TextStyle(
                              color: Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12,
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
        // const SizedBox(height: 10.0),
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
                  image: _baseUrl + items[index].image!,
                  imageHeight: imageHeight,
                  imageWidth: imageWidth,
                  fit: fit,
                  imagePadding: imagePadding,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20.0),
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
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
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
                            style: const TextStyle(
                              color: Color.fromARGB(255, 99, 167, 222),
                              fontSize: 12,
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
        // const SizedBox(height: 10.0),
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
                  image: _baseUrl + items[index].image!,
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
        const SizedBox(height: 20.0),
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
  final IconData? icon;
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
    this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(12.0),
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Padding(
              padding: imagePadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:
                    icon != null
                        ? [
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),

                            width: imageWidth,
                            height: imageHeight,
                            child: Center(
                              child: Icon(icon, size: 20, color: iconColor),
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
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
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
                      fontSize: titlefontSize ?? 14,
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
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    maxLines: maximumlines ?? 2,
                    details,
                    style: const TextStyle(
                      color: Color.fromARGB(221, 59, 58, 58),
                      fontSize: 12.0,
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

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;
  const ServiceDetailsScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Center(
        child: Text(
          'تفاصيل الخدمة: $serviceName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
