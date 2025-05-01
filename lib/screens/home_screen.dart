import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/build_boxes.dart';
import 'package:city/models/most_recent_products.dart';
import 'package:city/models/most_requested_products.dart';
import 'package:city/models/most_requested_services.dart';
import 'package:city/screens/all_services.dart';
import 'package:city/screens/government_screen.dart';
import 'package:city/services/get_most_recent_products.dart';
import 'package:city/services/get_most_requested_products.dart';
import 'package:city/services/get_most_requested_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
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

                    destination: const GovernmentScreen(),
                    fit: BoxFit.contain,
                    height: 150,

                    imageHeight: 50,
                    imagePadding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                    imageWidth: 50,
                    width: 160,
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
                    title: 'Products',
                    items: products,
                    titlefontSize: 12,
                    destination: const AllServices(),
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
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),

            _buildBoxesSection(
              context,
              'Providers',
              180,
              'category',
              150,
              'https://images.pexels.com/photos/1020370/pexels-photo-1020370.jpeg?auto=compress&cs=tinysrgb&w=600',
              80,
              180,
              BoxFit.cover,
              const EdgeInsets.fromLTRB(0, 0, 0, 4),
              5,
              const AllServices(),
            ),
            _buildBoxesSection(
              context,
              'Products',
              120,
              'details',
              120,
              'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?auto=compress&cs=tinysrgb&w=600',
              55,
              120,
              BoxFit.cover,
              const EdgeInsets.fromLTRB(0, 0, 0, 4),
              10,
              const AllServices(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBoxesSection(
    BuildContext context,

    String title,
    double width,
    String details,
    double height,
    String image,
    double imageHeight,
    double imageWidth,
    BoxFit fit,
    EdgeInsetsGeometry imagePadding,
    int itemCount,
    Widget destination,
  ) {
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
                                    Navigator.pop(context);
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
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ServiceDetailsScreen(
                              serviceName: '$title ${index + 1}',
                            ),
                      ),
                    ),
                child: ServiceBox(
                  title: '$title ${index + 1}',
                  width: width,
                  details: details,
                  image: image,
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

class ServiceBox extends StatelessWidget {
  final String title;
  final String details;
  final double width;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final BoxFit? fit;
  final EdgeInsetsGeometry imagePadding;
  const ServiceBox({
    super.key,
    required this.title,
    required this.width,
    required this.details,
    required this.image,
    required this.imageHeight,
    required this.imageWidth,
    required this.imagePadding,
    this.fit,
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
            // ignore: deprecated_member_use
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
                children: [
                  Image.network(
                    width: imageWidth,
                    height: imageHeight,
                    image,
                    fit: fit,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
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
                    maxLines: 2,
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
              data.map((i) => {'url': i.image, 'title': i.name}).toList();

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
                child: Text(
                  data['title']!,
                  style: const TextStyle(
                    color: MyColors.fontcolor,
                    fontSize: 18.0,
                    // fontWeight: FontWeight.bold,
                  ),
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
