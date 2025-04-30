// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/product_card.dart';
import 'package:city/models/category_sub_category_model.dart';
import 'package:flutter/material.dart';
import 'package:city/helper/api_service.dart';
import 'package:city/screens/subcategory_screen.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  int? selectedCategoryIndex;
  late TextEditingController _controller;
  List<CategoryModel>? _categories;
  bool _isLoadingCategories = true;
  String? _error;
  int _currentIndex = 0; // لتمرير الصور في الـ CarouselSlider
  List<String> imageList = [
    MyAssetsImage.burger, // أضف المسارات الحقيقية للصور هنا
    MyAssetsImage.sandwitch,
    MyAssetsImage.drink,
    MyAssetsImage.nescalop,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingCategories = false;
      });
    }
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
            _buildCategories(),
            if (selectedCategoryIndex != null) _buildSubCategories(),
            SizedBox(height: 15),
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

            // Page Indicators
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
            const Text(
              "أفضل التقييمات",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Column(
              children: const [
                Row(
                  children: [
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
                      image: MyAssetsImage.sandwitch,
                      price: "100 LE",
                      rating: 3.5,
                    ),
                    ProductCard(
                      description: 'الوصف الكامل للمنتج',
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

  Widget _buildCategories() {
    if (_isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text('حدث خطأ: $_error'));
    } else if (_categories == null || _categories!.isEmpty) {
      return const Center(child: Text('لا توجد فئات متاحة'));
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_categories!.length, (index) {
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
              child: CategoryCircle(
                name: _categories![index].nameAr,
                imageUrl: _categories![index].imageUrl,
                isSelected: selectedCategoryIndex == index,
              ),
            );
          }),
        ),
      );
    }
  }

  Widget _buildSubCategories() {
    return FutureBuilder<List<SubCategoryModel>>(
      future: ApiService.fetchSubCategories(
        _categories![selectedCategoryIndex!].id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('حدث خطأ: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('لا توجد تصنيفات فرعية'));
        } else {
          final subCategories = snapshot.data!;
          return SingleChildScrollView(
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
                              selectedCategoryIndex: selectedCategoryIndex!,
                              selectedSubCategoryIndex: index,
                            ),
                      ),
                    );
                  },
                  child: CategoryCircle(
                    name: subCategories[index].nameAr,
                    imageUrl: subCategories[index].imageUrl,
                  ),
                );
              }),
            ),
          );
        }
      },
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
