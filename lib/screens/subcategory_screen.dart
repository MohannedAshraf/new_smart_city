// ignore_for_file: avoid_print

import 'package:citio/core/widgets/category_circle.dart';
import 'package:citio/core/widgets/product_card.dart';
import 'package:citio/helper/api_product_under_sub.dart';
import 'package:citio/helper/api_service.dart';
import 'package:citio/models/category_sub_category_model.dart';
import 'package:citio/models/product_under_sub_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  List<ProductUnderSubModel> products = [];

  int selectedCategoryIndex = 0;
  int selectedSubCategoryIndex = 0;

  bool isLoadingCategories = true;
  bool isLoadingSubCategories = true;
  bool isLoadingProducts = false;

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
      setState(() => isLoadingCategories = false);
    }
  }

  Future<void> fetchSubCategories(int categoryId) async {
    setState(() {
      isLoadingSubCategories = true;
    });
    try {
      subCategories = await ApiService.fetchSubCategories(categoryId);
      selectedSubCategoryIndex = widget.selectedSubCategoryIndex;
      await fetchProducts(subCategories[selectedSubCategoryIndex].id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() => isLoadingSubCategories = false);
    }
  }

  Future<void> fetchProducts(int subCategoryId) async {
    setState(() => isLoadingProducts = true);
    try {
      products = await ApiProductUnderSub.fetchProductsBySubCategory(
        subCategoryId,
      );
      errorMessage = null; // reset error if success
    } catch (e, s) {
      errorMessage = e.toString();
      print("Exception while fetching products: $e");
      print(s); // Stack trace
    } finally {
      setState(() => isLoadingProducts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 70.w,
        height: 50.h,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartView()),
            );
          },
          icon: Icon(
            Icons.shopping_bag_sharp,
            color: Colors.white,
            size: 30.sp,
          ),
        ),
      ),
      // backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      appBar: AppBar(
        title: const Text('الخدمات'),
        centerTitle: true,
        //  backgroundColor: const Color.fromARGB(255, 220, 226, 223),
      ),
      body:
          errorMessage != null
              ? Center(child: Text('حدث خطأ: $errorMessage'))
              : isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),
                    _buildCategoryList(),
                    SizedBox(height: 10.h),
                    _buildSubCategoryList(),
                    SizedBox(height: 20.h),
                    isLoadingProducts
                        ? const Center(child: CircularProgressIndicator())
                        : products.isEmpty
                        ? const Center(child: Text('لا توجد منتجات'))
                        : _buildProductGrid(),
                  ],
                ),
              ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () async {
              setState(() {
                selectedCategoryIndex = index;
                selectedSubCategoryIndex = 0;
                products.clear();
              });
              await fetchSubCategories(category.id);
            },
            child: CategoryCircle(
              name: category.nameAr,
              imageUrl: category.imageUrl,
              isSelected: selectedCategoryIndex == index,
              radius: 30.r,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubCategoryList() {
    return isLoadingSubCategories
        ? const Center(child: CircularProgressIndicator())
        : subCategories.isEmpty
        ? const Center(child: Text('لا يوجد خدمات فرعية'))
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(subCategories.length, (index) {
              final subCategory = subCategories[index];
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    selectedSubCategoryIndex = index;
                    products.clear();
                  });
                  await fetchProducts(subCategory.id);
                },
                child: CategoryCircle(
                  name: subCategory.nameAr,
                  imageUrl: subCategory.imageUrl,
                  isSelected: selectedSubCategoryIndex == index,
                  radius: 25.r,
                ),
              );
            }),
          ),
        );
  }

  Widget _buildProductGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        double width = constraints.maxWidth;

        if (width >= 900) {
          crossAxisCount = 4;
        } else if (width >= 600) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 0.65,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final imageUrl =
                product.imageUrl.startsWith('http')
                    ? product.imageUrl
                    : '${ApiProductUnderSub.imageBaseUrl}${product.imageUrl}';

            return ProductCard(
              productId: product.id,
              image: imageUrl,
              price: "${product.price.toStringAsFixed(0)} LE",
              rating: product.rating,
              description: product.description,
              productName: product.nameAr,
            );
          },
        );
      },
    );
  }
}
