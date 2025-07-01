// ignore_for_file: avoid_print, unused_field, deprecated_member_use, duplicate_ignore

import 'package:citio/core/widgets/build_boxes.dart';
import 'package:citio/core/widgets/emergency_button.dart';
import 'package:citio/models/most_requested_products.dart';
import 'package:citio/screens/add_issue_screen.dart';
import 'package:citio/screens/government_services.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/services/get_most_requested_products.dart';
import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/most_recent_products.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/screens/all_vendors_screen.dart';

import 'package:citio/services/get_most_recent_products.dart';

import 'package:citio/services/get_most_requested_services.dart';
import 'package:citio/services/get_vendor.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: unused_element
String _baseUrl = 'https://service-provider.runasp.net';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اضغط مرة أخرى للخروج'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: MyColors.offWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: MyColors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 45,
                    children: [
                      const EmergencyButton(
                        color: MyColors.ambulanceShade,
                        emicon: Icon(
                          Icons.local_hospital,
                          color: MyColors.ambulance,
                        ),
                        emname: 'الإسعاف',
                        emergencyServiceId: '1',
                      ),
                      const EmergencyButton(
                        color: MyColors.firefighterShade,
                        emicon: Icon(
                          Icons.fire_truck,
                          color: MyColors.firefighter,
                        ),
                        emname: 'المطافئ',
                        emergencyServiceId: '2',
                      ),
                      const EmergencyButton(
                        color: MyColors.policeShade,
                        emicon: Icon(
                          Icons.local_police,
                          color: MyColors.police,
                        ),
                        emname: 'الشرطة',
                        emergencyServiceId: '3',
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const NewComplaintCenterPage(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.buttonGreenShade,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: MyColors.buttonGreen,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'أضف شكوى',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const CarouselWithIndicators(),
              const SizedBox(height: 20.0),
              FutureBuilder<List<MostRequested>>(
                future: MostRequestedServices().getMostRequestedServices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MostRequested> services = snapshot.data!;
                    return BuildBoxes(
                      title: 'الخدمات الحكومية',
                      items: services,
                      destination: const GovernmentServices(),
                      fit: BoxFit.contain,
                      height: 165,
                      imageHeight: 50,
                      imagePadding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                      imageWidth: 50,
                      width: 160,
                      maximumlines: 3,
                    );
                  } else {
                    return const SizedBox(
                      height: 140,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              FutureBuilder<List<MostRequestedProduct>>(
                future: MostRequestedProducts().getMostRequestedProduct(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<MostRequestedProduct> products = snapshot.data!;
                    return BuildProductsBoxes(
                      title: 'المنتجات',
                      items: products,
                      titlefontSize: 12,
                      destination: const ServiceOrderScreen(),
                      fit: BoxFit.cover,
                      height: 155,
                      maximumLines: 3,
                      imageHeight: 70,
                      imagePadding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      imageWidth: 190,
                      width: 190,
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              FutureBuilder<List<Vendor>>(
                future: GetVendor().getVendor(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Vendor> vendors = snapshot.data!;
                    return BuildVendorssBoxes(
                      title: 'البائعين',
                      items: vendors,
                      titlefontSize: 12,
                      destination: const AllVendorsScreen(),
                      fit: BoxFit.cover,
                      height: 160,
                      maximumLines: 3,
                      imageHeight: 70,
                      imagePadding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      imageWidth: 180,
                      width: 180,
                    );
                  } else {
                    return const SizedBox(
                      height: 160,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//comment

class CarouselWithIndicators extends StatefulWidget {
  const CarouselWithIndicators({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselWithIndicatorsState createState() => _CarouselWithIndicatorsState();
}

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'ماذا تريد ',
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.ghostColor),
          borderRadius: BorderRadius.circular(25.0.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class _CarouselWithIndicatorsState extends State<CarouselWithIndicators> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MostRecentProduct>>(
      future: MostRecentProducts().getMostRecentProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MostRecentProduct> data = snapshot.data!;
          List<ImageCard> cards = generateCards(data);

          return Column(
            children: [
              CarouselSlider(
                items: cards,
                options: CarouselOptions(
                  height: 150.0.h,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged:
                      (index, reason) => setState(() => _currentIndex = index),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          );
        } else {
          return SizedBox(
            height: 150.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  List<ImageCard> generateCards(List<MostRecentProduct> data) {
    List<ImageCard> cards = [];
    for (MostRecentProduct p in data) {
      cards.add(ImageCard(data: p));
    }
    return cards;
  }
}

class ImageCard extends StatelessWidget {
  final MostRecentProduct data;
  const ImageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ProductDetailsView(productId: data.product.id),
            ),
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0.r),
        child: Stack(
          children: [
            Image.network(
              _baseUrl + data.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return SizedBox(
                  height: 150.h,
                  child: const Image(
                    image: AssetImage(MyAssetsImage.brokenImage),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20.0.h,
              left: 10.0.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0.w,
                  vertical: 5.0.h,
                ),
                // ignore: deprecated_member_use
                color: Colors.transparent,
                child: StrokeText(
                  height: 10.h,
                  width: 10.w,
                  text: data.name,
                  textSize: 14.sp,
                  textColor: MyColors.white,
                  strokeColor: MyColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Indicator extends StatelessWidget {
  final bool isActive;
  const Indicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.0.w,
      height: 8.0.h,
      margin: EdgeInsets.symmetric(horizontal: 4.0.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }
}

class StrokeText extends StatefulWidget {
  const StrokeText({
    super.key,
    this.width,
    this.height,
    this.text,
    this.textSize,
    this.textColor,
    this.strokeColor,
    this.letterSpacing,
    this.strokeWidth,
  });

  final double? width;
  final double? height;
  final String? text;
  final double? textSize;
  final Color? textColor;
  final Color? strokeColor;
  final double? letterSpacing;
  final double? strokeWidth;

  @override
  State<StrokeText> createState() => _StrokeTextState();
}

class _StrokeTextState extends State<StrokeText> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Implement the stroke
        Text(
          maxLines: 2,
          textAlign: TextAlign.left,
          widget.text ?? '',
          style: TextStyle(
            fontSize: widget.textSize ?? 16.sp,
            letterSpacing: widget.letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.strokeWidth ?? 3
                  ..color = widget.strokeColor ?? Colors.black,
          ),
        ),
        // The text inside
        Text(
          widget.text ?? '',
          style: TextStyle(
            fontSize: widget.textSize ?? 16.sp,
            letterSpacing: widget.letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            color: widget.textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
