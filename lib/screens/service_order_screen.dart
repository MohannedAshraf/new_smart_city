// ignore_for_file: prefer_const_constructors, avoid_print, prefer_final_fields, unused_field, deprecated_member_use
import 'package:citio/core/utils/project_strings.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/app_strings.dart';
import 'package:citio/helper/api_banner.dart';
import 'package:citio/helper/api_most_product.dart';
import 'package:citio/helper/api_service.dart';
import 'package:citio/models/banner_model.dart';
import 'package:citio/models/category_sub_category_model.dart';
import 'package:citio/models/product_model.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:citio/screens/search_result_screen.dart';
import 'package:citio/screens/subcategory_screen.dart';
import 'package:citio/core/widgets/category_circle.dart';
import 'package:citio/core/widgets/product_card.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  State<ServiceOrderScreen> createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  int? selectedCategoryIndex;
  late TextEditingController _controller;
  List<CategoryModel>? _categories;
  List<BannerModel>? _banners;
  bool _isLoadingCategories = true;
  bool _isLoadingBanners = true;
  String? _error, _bannerError;
  DateTime? lastBackPressTime;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCategories();
    _loadBanners();
  }

  Future<void> _loadCategories() async {
    try {
      final data = await ApiService.fetchCategories();
      setState(() {
        _categories = data;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadBanners() async {
    try {
      final data = await ApiTopBanners.fetchTopBanners();
      setState(() {
        _banners = data;
        _isLoadingBanners = false;
      });
    } catch (e) {
      setState(() {
        _bannerError = e.toString();
        _isLoadingBanners = false;
      });
    }
  }

  void _performSearch() {
    final keyword = _controller.text.trim();
    if (keyword.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SearchResultsPage(keyword: keyword)),
      );
    }
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.pressAgainToExit)));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: Container(
          width: media.width * 0.15,
          height: media.height * 0.07,
          decoration: BoxDecoration(
            color: MyColors.primary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.shopping_bag, color: Colors.white),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartView()),
                ),
          ),
        ),
        appBar: AppBar(title: Text(AppStrings.serviceOrder), centerTitle: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: media.height * 0.02),
              _buildSearchBar(media),
              SizedBox(height: media.height * 0.02),
              _buildCategories(),
              if (selectedCategoryIndex != null) _buildSubCategories(),
              SizedBox(height: media.height * 0.02),
              _isLoadingBanners
                  ? Center(child: CircularProgressIndicator())
                  : _bannerError != null
                  ? Center(child: Text(AppStrings.bannerLoadError))
                  : BannerSliderWidget(banners: _banners!),
              SizedBox(height: media.height * 0.02),
              Text(
                AppStrings.bestRated,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: media.width * 0.06,
                ),
              ),
              MostRequestedProductsView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(Size media) {
    return SizedBox(
      height: media.height * 0.06,
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _performSearch(),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          prefixIcon: InkWell(
            onTap: _performSearch,
            child: Icon(Icons.search, size: media.width * 0.06),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: media.width * 0.04,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategories() {
    if (_isLoadingCategories) {
      return Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      return Center(child: Text(AppStrings.categoryLoadError));
    } else if (_categories == null || _categories!.isEmpty) {
      return Center(child: Text(AppStrings.noCategories));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_categories!.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryIndex =
                    (selectedCategoryIndex == index) ? null : index;
              });
            },
            child: CategoryCircle(
              name: _categories![index].nameAr,
              imageUrl: _categories![index].imageUrl,
              isSelected: selectedCategoryIndex == index,
              radius: 30,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSubCategories() {
    return FutureBuilder<List<SubCategoryModel>>(
      future: ApiService.fetchSubCategories(
        _categories![selectedCategoryIndex!].id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(AppStrings.subCategoryLoadError));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(AppStrings.noSubCategories));
        }

        final subCats = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(subCats.length, (index) {
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SubCategoryScreen(
                              selectedCategoryIndex: selectedCategoryIndex!,
                              selectedSubCategoryIndex: index,
                            ),
                      ),
                    ),
                child: CategoryCircle(
                  name: subCats[index].nameAr,
                  imageUrl: subCats[index].imageUrl,
                  radius: 25,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return SizedBox(
      height: media.height * 0.055,
      child: TextField(
        controller: controller,
        onSubmitted: (_) => onSearch(),
        style: TextStyle(fontSize: media.width * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 0,
            horizontal: media.width * 0.04,
          ),
          hintText: AppStrings.searchHint,
          prefixIcon: InkWell(
            onTap: onSearch,
            child: Icon(Icons.search, size: media.width * 0.06),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black87),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

class BannerSliderWidget extends StatefulWidget {
  final List<BannerModel> banners;
  const BannerSliderWidget({super.key, required this.banners});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Column(
      children: [
        CarouselSlider(
          items:
              widget.banners.map((banner) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ProductDetailsView(
                                productId: banner.productId,
                              ),
                        ),
                      );
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "${ApiTopBanners.baseUrl}${banner.imageUrl}",
                          fit: BoxFit.fill,
                          width: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                        ),
                        Positioned(
                          bottom: media.height * 0.01,
                          left: media.width * 0.02,
                          child: Container(
                            color: Colors.black54,
                            padding: EdgeInsets.symmetric(
                              horizontal: media.width * 0.02,
                              vertical: media.height * 0.01,
                            ),
                            child: Text(
                              banner.description,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          options: CarouselOptions(
            height: media.height * 0.23,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}

class MostRequestedProductsView extends StatefulWidget {
  const MostRequestedProductsView({super.key});

  @override
  State<MostRequestedProductsView> createState() =>
      _MostRequestedProductsViewState();
}

class _MostRequestedProductsViewState extends State<MostRequestedProductsView> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = ProductService.fetchMostRequestedProducts();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '${AppStrings.productLoadError} ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(AppStrings.noProductshere));
          }

          final products = snapshot.data!;

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
                padding: EdgeInsets.symmetric(
                  horizontal: media.width * 0.025,
                  vertical: media.height * 0.015,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: media.width * 0.02,
                  mainAxisSpacing: media.height * 0.015,
                  childAspectRatio: 0.58,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    productId: product.id,
                    image: ProductService.baseUrl + product.mainImageUrl,
                    price: '${product.price.toStringAsFixed(0)} LE',
                    rating: (product.requestCount / 5).clamp(0, 5).toDouble(),
                    description: product.description,
                    productName: product.nameEn,
                  );
                },
              );
            },
          );
        } catch (e, stackTrace) {
          print('❌ Exception caught in FutureBuilder: $e');
          print('📍 Stack trace: $stackTrace');
          return Center(
            child: Text(
              AppStrings.unexpectedError,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
