import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/product_card.dart';
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

  final List<String> categories = [
    "طعام",
    "مشروبات",
    "ملابس",
    "الكترون",
    "الصحة",
    "خدمات",
    "تعليم",
    "ترفيه",
    "أثاث",
    "سيارات",
  ];

  final List<String> subCategories = [
    "فرعي 1",
    "فرعي 2",
    "فرعي 3",
    "فرعي 4",
    "فرعي 5",
    "فرعي 6",
    "فرعي 7",
    "فرعي 8",
  ];

  int? selectedCategoryIndex;

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategoryIndex == index) {
                          selectedCategoryIndex = null;
                        } else {
                          selectedCategoryIndex = index;
                        }
                      });
                    },
                    child: CategoryCircle(circlename: categories[index]),
                  );
                }),
              ),
            ),
            if (selectedCategoryIndex != null) ...[
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(subCategories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SubCategoryScreen(
                                  subCategoryName: subCategories[index],
                                ),
                          ),
                        );
                      },
                      child: CategoryCircle(circlename: subCategories[index]),
                    );
                  }),
                ),
              ),
            ],
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
        hintText: 'ماذا تريد',
        prefixIcon: const Icon(Icons.search),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(25.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class SubCategoryScreen extends StatelessWidget {
  final String subCategoryName;

  const SubCategoryScreen({super.key, required this.subCategoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategoryName),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // اتنين جنب بعض
          childAspectRatio: 3 / 4,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
        ),
        itemCount: 20, // عدد المنتجات اللي عايز تظهره
        itemBuilder: (context, index) {
          return const ProductCard(
            image: MyAssetsImage.sandwitch,
            price: "100 LE",
            rating: 3.5,
          );
        },
      ),
    );
  }
}
