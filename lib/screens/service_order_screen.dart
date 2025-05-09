// ignore_for_file: prefer_const_constructors, avoid_print
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/helper/api_banner.dart';
import 'package:citio/helper/api_search.dart';
import 'package:citio/models/banner_model.dart';
import 'package:citio/models/search_model.dart';
import 'package:citio/screens/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:citio/core/widgets/category_circle.dart';
import 'package:citio/core/widgets/product_card.dart';
import 'package:citio/helper/api_most_product.dart';
import 'package:citio/models/category_sub_category_model.dart';
import 'package:citio/models/product_model.dart';
import 'package:citio/helper/api_service.dart';
import 'package:citio/screens/subcategory_screen.dart';
import 'package:flutter_svg/svg.dart';

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
  int _currentIndex = 0;
  // لتمرير الصور في الـ CarouselSlider
  List<BannerModel>? _banners;
  bool _isLoadingBanners = true;
  String? _bannerError;
  List<SearchResultModel>? _searchResults;
  bool _isSearching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _loadCategories();
    _loadBanners();
    _controller = TextEditingController();
  }

  Future<void> _performSearch() async {
    final term = _controller.text.trim();
    if (term.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
      _searchResults = null;
    });

    try {
      final results = await ApiSearch.search(term);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _searchError = e.toString();
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _loadBanners() async {
    try {
      final banners = await ApiTopBanners.fetchTopBanners();
      setState(() {
        _banners = banners;
        _isLoadingBanners = false;
      });
    } catch (e) {
      setState(() {
        _bannerError = e.toString();
        _isLoadingBanners = false;
      });
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MySearchBar(
                controller: _controller,
                onSearch: _performSearch,
              ),
            ),
            if (_isSearching) ...[
              const Center(child: CircularProgressIndicator()),
            ] else if (_searchError != null) ...[
              Center(child: Text('❌ خطأ في البحث: $_searchError')),
            ] else if (_searchResults != null) ...[
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      _searchResults!.map((result) {
                        return Card(
                          child: ListTile(
                            leading:
                                result.imageUrl != null
                                    ? Image.network(
                                      result.imageUrl!,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                    : const Icon(Icons.image_not_supported),
                            title: Text(
                              result.nameAr ??
                                  result.nameEn ??
                                  result.businessName ??
                                  'بدون اسم',
                            ),
                            subtitle: Text(
                              result.categoryNameAr ??
                                  result.categoryNameEn ??
                                  '',
                            ),
                            onTap: () {
                              // يمكنك لاحقًا التنقل لصفحة التفاصيل هنا
                              print("فتح تفاصيل العنصر: ${result.id}");
                            },
                          ),
                        );
                      }).toList(),
                ),
              ),
            ],
            const SizedBox(height: 30),
            _buildCategories(),
            if (selectedCategoryIndex != null) _buildSubCategories(),
            SizedBox(height: 70),
            _isLoadingBanners
                ? const Center(child: CircularProgressIndicator())
                : _bannerError != null
                ? Center(child: Text('❌ خطأ في تحميل الإعلانات: $_bannerError'))
                : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        print("go to product with discount");
                      },
                      child: CarouselSlider(
                        items:
                            _banners!.map((banner) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      //'https://service-provider.runasp.net'
                                      "${ApiTopBanners.baseUrl}${banner.imageUrl}",
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Container(
                                        color: Colors.black54,
                                        padding: const EdgeInsets.all(8),
                                        child: Text(
                                          banner.description,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _banners!.length,
                        (index) => Container(
                          width: 10.0,
                          height: 10.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                _currentIndex == index
                                    ? const Color(0xFF3D6643)
                                    : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

            const SizedBox(height: 10),

            // Page Indicators
            const SizedBox(height: 30),
            const Text(
              "أفضل التقييمات",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),
            MostRequestedProductsView(),
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
  final TextEditingController controller;
  final VoidCallback onSearch;

  const MySearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        hintText: 'ماذا تريد',
        prefixIcon: InkWell(onTap: onSearch, child: const Icon(Icons.search)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(20.0),
        ),
        filled: true,
        fillColor: MyColors.newbackground,
      ),
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
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        try {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                '❌ حصل خطأ أثناء تحميل المنتجات: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا يوجد منتجات متاحة حالياً.'));
          }

          final products = snapshot.data!;

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 جمب بعض
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
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
        } catch (e, stackTrace) {
          print('❌ Exception caught in FutureBuilder: $e');
          print('📍 Stack trace: $stackTrace');
          return Center(
            child: Text(
              'حدث خطأ غير متوقع 😢',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
      },
    );
  }
}
