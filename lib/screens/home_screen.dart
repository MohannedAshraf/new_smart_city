// ignore_for_file: avoid_print, unused_field, deprecated_member_use, duplicate_ignore, library_private_types_in_public_api

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/build_boxes.dart';
import 'package:citio/core/widgets/emergency_button.dart';
import 'package:citio/models/most_requested_products.dart';
import 'package:citio/screens/add_issue_screen.dart';
import 'package:citio/screens/government_services.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/services/get_most_requested_products.dart';
import 'package:citio/core/utils/assets_image.dart';
import 'package:citio/models/most_recent_products.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/models/vendor.dart';
import 'package:citio/screens/all_vendors_screen.dart';
import 'package:citio/services/get_most_recent_products.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:citio/services/get_vendor.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

String _baseUrl = Urls.serviceProviderbaseUrl;

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
          content: Text(AppStrings.pressAgainToExit),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: MyColors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: MyColors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.04,
                    16,
                    screenWidth * 0.04,
                    14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EmergencyButton(
                        color: MyColors.ambulanceShade,
                        emicon: Icon(
                          Icons.local_hospital,
                          color: MyColors.ambulance,
                        ),
                        emname: AppStrings.ambulance1,
                        emergencyServiceId: '1',
                      ),
                      SizedBox(width: screenWidth * .1),
                      const EmergencyButton(
                        color: MyColors.firefighterShade,

                        emicon: Icon(
                          Icons.fire_truck,
                          color: MyColors.firefighter,
                        ),
                        emname: AppStrings.fireFighter1,
                        emergencyServiceId: '2',
                      ),
                      SizedBox(width: screenWidth * .1),
                      const EmergencyButton(
                        color: MyColors.policeShade,
                        emicon: Icon(
                          Icons.local_police,
                          color: MyColors.police,
                        ),
                        emname: AppStrings.police,
                        emergencyServiceId: '3',
                      ),
                      SizedBox(width: screenWidth * .1),
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
                              width: screenWidth * 0.0988,
                              height: screenWidth * 0.0988,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: MyColors.primary,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: MyColors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.009),
                          Text(
                            AppStrings.addComplaint1,
                            style: TextStyle(
                              fontSize: screenWidth * 0.031,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const CarouselWithIndicators(),
              SizedBox(height: screenHeight * 0.02),
              FutureBuilder<List<MostRequested>>(
                future: MostRequestedServices().getMostRequestedServices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return BuildBoxes(
                      title: AppStrings.governmentServices1,
                      items: snapshot.data!,
                      destination: const GovernmentServices(),
                      fit: BoxFit.contain,
                      height: screenHeight * 0.26,
                      imageHeight: screenHeight * 0.075,
                      imagePadding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                      imageWidth: screenWidth * 0.2,
                      width: screenWidth * 0.5,
                      maximumlines: 3,
                    );
                  } else {
                    return SizedBox(
                      height: screenHeight * 0.26,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              FutureBuilder<List<MostRequestedProduct>>(
                future: MostRequestedProducts().getMostRequestedProduct(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return BuildProductsBoxes(
                      title: AppStrings.products1,
                      items: snapshot.data!,
                      titlefontSize: screenWidth * 0.03,
                      destination: const ServiceOrderScreen(),
                      fit: BoxFit.cover,
                      height: screenHeight * 0.27,
                      maximumLines: 3,
                      imageHeight: screenHeight * 0.087,
                      imagePadding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      imageWidth: screenWidth * 0.5,
                      width: screenWidth * 0.5,
                    );
                  } else {
                    return SizedBox(
                      height: screenHeight * 0.27,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
              FutureBuilder<List<Vendor>>(
                future: GetVendor().getVendor(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return BuildVendorssBoxes(
                      title: AppStrings.vendors1,
                      items: snapshot.data!,
                      titlefontSize: screenWidth * 0.03,
                      destination: const AllVendorsScreen(),
                      fit: BoxFit.cover,
                      height: screenHeight * 0.25,
                      maximumLines: 3,
                      imageHeight: screenHeight * 0.09,
                      imagePadding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                      imageWidth: screenWidth * 0.48,
                      width: screenWidth * 0.48,
                    );
                  } else {
                    return SizedBox(
                      height: screenHeight * 0.26,
                      child: const Center(child: CircularProgressIndicator()),
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
  _CarouselWithIndicatorsState createState() => _CarouselWithIndicatorsState();
}

class _CarouselWithIndicatorsState extends State<CarouselWithIndicators> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
                  height: screenHeight * 0.2,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged:
                      (index, reason) => setState(() => _currentIndex = index),
                ),
              ),
              const SizedBox(height: 10),
            ],
          );
        } else {
          return SizedBox(
            height: screenHeight * 0.2,
            child: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  List<ImageCard> generateCards(List<MostRecentProduct> data) {
    return data.map((p) => ImageCard(data: p)).toList();
  }
}

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final radius = MediaQuery.of(context).size.width * 0.07;

    return TextField(
      decoration: InputDecoration(
        hintText: AppStrings.whatDoYouWant,
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: MyColors.ghostColor),
          borderRadius: BorderRadius.circular(radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final MostRecentProduct data;
  const ImageCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        borderRadius: BorderRadius.circular(screenWidth * 0.025),
        child: Stack(
          children: [
            Image.network(
              _baseUrl + data.image!,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder:
                  (_, __, ___) => SizedBox(
                    height: screenHeight * 0.2,
                    child: const Image(
                      image: AssetImage(MyAssetsImage.brokenImage),
                    ),
                  ),
            ),
            Positioned(
              bottom: screenHeight * 0.03,
              left: screenWidth * 0.03,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.01,
                ),
                color: Colors.transparent,
                child: StrokeText(
                  text: data.name,
                  textSize: screenWidth * 0.035,
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
    final size = MediaQuery.of(context).size.width * 0.02;

    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(horizontal: size / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }
}

class StrokeText extends StatelessWidget {
  final String? text;
  final double? textSize;
  final Color? textColor;
  final Color? strokeColor;
  final double? letterSpacing;
  final double? strokeWidth;

  const StrokeText({
    super.key,
    this.text,
    this.textSize,
    this.textColor,
    this.strokeColor,
    this.letterSpacing,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text ?? '',
          maxLines: 2,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: textSize ?? 16,
            letterSpacing: letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth ?? 3
                  ..color = strokeColor ?? Colors.black,
          ),
        ),
        Text(
          text ?? '',
          style: TextStyle(
            fontSize: textSize ?? 16,
            letterSpacing: letterSpacing ?? 0,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}
