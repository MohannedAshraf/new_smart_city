// الكود زي ما هو
import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/category_circle.dart';
import 'package:city/core/widgets/product_card.dart';
import 'package:city/helper/api_service.dart';
import 'package:city/models/category_sub_category_model.dart';
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
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];

  int selectedCategoryIndex = 0;
  int selectedSubCategoryIndex = 0;

  bool isLoadingCategories = true;
  bool isLoadingSubCategories = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    try {
      categories = await ApiService.fetchCategories();
      if (categories.isNotEmpty) {
        selectedCategoryIndex = widget.selectedCategoryIndex;
        await fetchSubCategories(categories[selectedCategoryIndex].id);
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> fetchSubCategories(int categoryId) async {
    if (mounted) {
      setState(() {
        isLoadingSubCategories = true;
      });
    }
    try {
      subCategories = await ApiService.fetchSubCategories(categoryId);
      selectedSubCategoryIndex = widget.selectedSubCategoryIndex;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          isLoadingSubCategories = false;
        });
      }
    }
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
          width: 80,
          height: 60,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      appBar: AppBar(
        title: const Text('الخدمات'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      ),
      body:
          errorMessage != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('حدث خطأ: $errorMessage'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchInitialData,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              )
              : isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(categories.length, (index) {
                          final category = categories[index];
                          return GestureDetector(
                            onTap: () async {
                              if (mounted) {
                                setState(() {
                                  selectedCategoryIndex = index;
                                  selectedSubCategoryIndex = 0;
                                });
                              }
                              await fetchSubCategories(category.id);
                            },
                            child: CategoryCircle(
                              name: category.nameAr,
                              imageUrl: category.imageUrl,
                              isSelected: selectedCategoryIndex == index,
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 10),
                    isLoadingSubCategories
                        ? const Center(child: CircularProgressIndicator())
                        : subCategories.isEmpty
                        ? const Center(child: Text('لا يوجد خدمات فرعية'))
                        : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(subCategories.length, (
                              index,
                            ) {
                              final subCategory = subCategories[index];
                              return GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      selectedSubCategoryIndex = index;
                                    });
                                  }
                                },
                                child: CategoryCircle(
                                  name: subCategory.nameAr,
                                  imageUrl: subCategory.imageUrl,
                                  isSelected: selectedSubCategoryIndex == index,
                                ),
                              );
                            }),
                          ),
                        ),
                    const SizedBox(height: 20),
                    // هنا هنعرض المنتجات بناءً على الـ subCategory المختار
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 8.5 / 12,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                      itemCount:
                          subCategories.isNotEmpty
                              ? 5 // عدد المنتجات المؤقتة
                              : 0,
                      itemBuilder: (context, index) {
                        // بيانات المنتجات الوهمية مؤقتًا
                        return const ProductCard(
                          productId: 5,
                          image: MyAssetsImage.burger,
                          price: "100 LE",
                          rating: 3.5,
                          description: 'وصف المنتج هنا',
                          productName: 'dsaasasaa',
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }
}
