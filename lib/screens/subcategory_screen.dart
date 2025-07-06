import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/widgets/category_circle.dart';
import 'package:citio/core/widgets/product_card.dart';
import 'package:citio/helper/api_product_under_sub.dart';
import 'package:citio/helper/api_service.dart';
import 'package:citio/models/category_sub_category_model.dart';
import 'package:citio/models/product_under_sub_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';

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
      errorMessage = null;
    } catch (e, s) {
      errorMessage = e.toString();
      print("Exception while fetching products: $e");
      print(s);
    } finally {
      setState(() => isLoadingProducts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      floatingActionButton: Container(
        width: screenWidth * 0.18,
        height: screenHeight * 0.07,
        decoration: const BoxDecoration(
          color: MyColors.primary,
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
            size: screenWidth * 0.08,
          ),
        ),
      ),
      appBar: AppBar(title: const Text(AppStrings.services), centerTitle: true),
      body:
          errorMessage != null
              ? Center(child: Text('${AppStrings.errorOccurred} $errorMessage'))
              : isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryList(screenWidth),
                      SizedBox(height: screenHeight * 0.02),
                      _buildSubCategoryList(screenWidth),
                      SizedBox(height: screenHeight * 0.03),
                      isLoadingProducts
                          ? const Center(child: CircularProgressIndicator())
                          : products.isEmpty
                          ? const Center(child: Text(AppStrings.noProducts))
                          : _buildProductGrid(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildCategoryList(double screenWidth) {
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
              radius: screenWidth * 0.08,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubCategoryList(double screenWidth) {
    return isLoadingSubCategories
        ? const Center(child: CircularProgressIndicator())
        : subCategories.isEmpty
        ? const Center(child: Text(AppStrings.noSubServices))
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
                  radius: screenWidth * 0.07,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
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
