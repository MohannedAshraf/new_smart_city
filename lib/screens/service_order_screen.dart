import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:city/core/utils/assets_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ServiceOrderScreen(),
    );
  }
}

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
  int? selectedSubCategoryIndex;

  int _currentIndex = 0;

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
                        selectedCategoryIndex = index;
                        selectedSubCategoryIndex = null;
                      });
                    },
                    child: CategoryCircle(
                      circlename: categories[index],
                      isSelected: selectedCategoryIndex == index,
                    ),
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
                                  selectedCategoryName:
                                      categories[selectedCategoryIndex!],
                                  selectedSubCategoryName: subCategories[index],
                                ),
                          ),
                        );
                      },
                      child: CategoryCircle(
                        circlename: subCategories[index],
                        isSelected: false, // هنا مش مختار حاجة لسة
                      ),
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
          ],
        ),
      ),
    );
  }
}

class SubCategoryScreen extends StatelessWidget {
  final String selectedCategoryName;
  final String selectedSubCategoryName;

  const SubCategoryScreen({
    super.key,
    required this.selectedCategoryName,
    required this.selectedSubCategoryName,
  });

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedSubCategoryName),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                return CategoryCircle(
                  circlename: categories[index],
                  isSelected: categories[index] == selectedCategoryName,
                );
              }),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(subCategories.length, (index) {
                return CategoryCircle(
                  circlename: subCategories[index],
                  isSelected: subCategories[index] == selectedSubCategoryName,
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          // هنا تحط المنتجات بتاعتك مثلا GridView وغيره
          const Expanded(child: Center(child: Text('المنتجات هتظهر هنا'))),
        ],
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

class CategoryCircle extends StatelessWidget {
  final String circlename;
  final bool isSelected;

  const CategoryCircle({
    super.key,
    required this.circlename,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFF3D6643), // ثابت أخضر
            child: Icon(Icons.category, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            circlename,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.black, // النص فقط بيتغير
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.price,
    required this.rating,
    required this.description,
  });

  final String image;
  final String price;
  final double rating;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 175,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Image.asset(image, fit: BoxFit.fitHeight),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: [
                Text("اسم المنتج "),
                SizedBox(width: 40),
                Text("اسم المالك "),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // لضمان محاذاة العناصر بداية السطر
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description.length > 15
                      ? '${description.substring(0, 15)}...'
                      : description,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                if (description.length > 15)
                  InkWell(
                    onTap: () {
                      // ignore: avoid_print
                      print("clik");
                    },
                    child: const Text(
                      'عرض المزيد',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                      ), // يمكنك تغيير اللون حسب الحاجة
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(price),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60),
            child: RatingBarIndicator(
              rating: rating,
              itemBuilder:
                  (context, index) =>
                      const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}
