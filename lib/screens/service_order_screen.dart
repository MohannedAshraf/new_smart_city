import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/product_card.dart';
import 'package:city/screens/subcategory_screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  final List<String> imageList = [
    MyAssetsImage.burger,
    MyAssetsImage.sandwitch,
    MyAssetsImage.drink,
    MyAssetsImage.nescalop,
  ];

  late TextEditingController _controller;
  String searchText = "";
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 220, 226, 223),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("طلب الخدمات"),
      ),
      //  backgroundColor: MyColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: MySearchBar(),
            ),

            const SizedBox(height: 30),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CategoryCircle(circlename: "طعام"),
                  CategoryCircle(circlename: "مشروبات"),
                  CategoryCircle(circlename: "ملابس"),
                  CategoryCircle(circlename: "الكترو"),
                  CategoryCircle(circlename: "الصحه "),
                  CategoryCircle(circlename: "خدمات"),
                  CategoryCircle(circlename: "تعليم"),
                  CategoryCircle(circlename: "ترفيه"),
                  CategoryCircle(circlename: "اثاث"),
                  CategoryCircle(circlename: " سيارات "),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CarouselSlider(
              items:
                  imageList.map((imagePath) {
                    return Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  }).toList(),
              options: CarouselOptions(
                height: 190.0,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  imageList.asMap().entries.map((entry) {
                    return Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentIndex == entry.key
                                ? const Color(0xFF3D6643)
                                : Colors.grey,
                      ),
                    );
                  }).toList(),
            ),

            const SizedBox(height: 30),

            const Column(
              children: [
                Row(
                  children: [
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
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
          borderSide: const BorderSide(color: Colors.grey),
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
