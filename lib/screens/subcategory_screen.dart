import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/product_card.dart';
import 'package:city/screens/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SubCategoryScreen extends StatefulWidget {
  final int selectedCategoryIndex;
  final int selectedSubCategoryIndex;

  const SubCategoryScreen({
    super.key,
    required this.selectedCategoryIndex,
    required this.selectedSubCategoryIndex,
  });

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
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

  late int selectedCategoryIndex;
  late int selectedSubCategoryIndex;

  @override
  void initState() {
    super.initState();
    selectedCategoryIndex = widget.selectedCategoryIndex;
    selectedSubCategoryIndex = widget.selectedSubCategoryIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartView()),
          );
        },
        child: SvgPicture.asset(
          "assets/icon/actionbutton.svg",
          width: 80, // حجم مناسب للزر
          height: 60,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      appBar: AppBar(
        title: const Text('الخدمات'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
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
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(subCategories.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSubCategoryIndex = index;
                      });
                    },
                    child: CategoryCircle(
                      circlename: subCategories[index],
                      isSelected: selectedSubCategoryIndex == index,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 8.5 / 12,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return const ProductCard(
                  image: MyAssetsImage.sandwitch,
                  price: "100 LE",
                  rating: 3.5,
                  description: 'وصف المنتج هنا',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
