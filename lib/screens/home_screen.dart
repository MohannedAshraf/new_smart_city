// ignore_for_file: avoid_print

import 'package:citio/core/widgets/build_boxes.dart';
import 'package:citio/core/widgets/emergency_button.dart';
import 'package:citio/models/most_requested_products.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/services/get_most_requested_products.dart';
import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/models/most_recent_products.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/screens/all_vendors_screen.dart';
import 'package:citio/screens/gov_services_datails.dart';

import 'package:citio/services/get_most_recent_products.dart';

import 'package:citio/services/get_most_requested_services.dart';
import 'package:citio/services/get_vendor.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

String _baseUrl = 'https://service-provider.runasp.net';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 45,
                children: [
                  const EmergencyButton(
                    color: MyColors.themecolor,
                    emicon: Icon(Icons.local_hospital, color: MyColors.oldLace),
                    emname: 'الإسعاف',
                    emergencyServiceId: '1',
                  ),
                  const EmergencyButton(
                    color: MyColors.themecolor,
                    emicon: Icon(Icons.fire_truck, color: MyColors.oldLace),
                    emname: 'المطافئ',
                    emergencyServiceId: '2',
                  ),
                  const EmergencyButton(
                    color: MyColors.themecolor,
                    emicon: Icon(Icons.local_police, color: MyColors.oldLace),
                    emname: 'الشرطة',
                    emergencyServiceId: '3',
                  ),
                  ////;,lkh
                  Column(
                    children: [
                      InkWell(
                        onTap: () => print('Icon Button Pressed'),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: MyColors.themecolor,
                          ),
                          child: const Icon(Icons.add, color: MyColors.oldLace),
                        ),
                      ),
                      const Text(
                        'أضف شكوى',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.all(16.0), child: MySearchBar()),
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

                    destination: const GovServicesDatails(),
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
                    height: 150,
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
    );
  }
}

//comment
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
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class CarouselWithIndicators extends StatefulWidget {
  const CarouselWithIndicators({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselWithIndicatorsState createState() => _CarouselWithIndicatorsState();
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
          List<Map<String, String>> products =
              data
                  .map((i) => {'url': _baseUrl + i.image!, 'title': i.name})
                  .toList();

          return Column(
            children: [
              CarouselSlider(
                items: products.map((data) => ImageCard(data: data)).toList(),
                options: CarouselOptions(
                  height: 150.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged:
                      (index, reason) => setState(() => _currentIndex = index),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  products.length,
                  (index) => Indicator(isActive: _currentIndex == index),
                ),
              ),
            ],
          );
        } else {
          return const SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class ImageCard extends StatelessWidget {
  final Map<String, String> data;
  const ImageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      ServiceDetailsScreen(serviceName: data['title']!),
            ),
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          children: [
            Image.network(
              data['url']!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (
                BuildContext context,
                Object error,
                StackTrace? stackTrace,
              ) {
                return const SizedBox(
                  height: 150,
                  child: Image(image: AssetImage(MyAssetsImage.brokenImage)),
                );
              },
            ),
            Positioned(
              bottom: 20.0,
              left: 10.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 5.0,
                ),
                // ignore: deprecated_member_use
                color: Colors.transparent,
                child: StrokeText(
                  height: 10,
                  width: 10,
                  text: data['title'],
                  textSize: 14,
                  textColor: MyColors.white,
                  strokeColor: MyColors.black,
                ),
                /*Text(
                  data['title']!,
                  style: const TextStyle(
                    color: MyColors.fontcolor,
                    fontSize: 16.0,
                    // fontWeight: FontWeight.bold,
                  ),
                ),*/
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
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
            fontSize: widget.textSize ?? 16,
            letterSpacing: widget.letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = widget.strokeWidth ?? 4
                  ..color = widget.strokeColor ?? Colors.black,
          ),
        ),
        // The text inside
        Text(
          widget.text ?? '',
          style: TextStyle(
            fontSize: widget.textSize ?? 16,
            letterSpacing: widget.letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            color: widget.textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
