import 'package:citio/core/utils/project_strings.dart' show AppStrings;
import 'package:flutter/material.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api_search.dart';
import 'package:citio/models/search_model.dart';
import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/subcategory_screen.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/screens/vendor_profile.dart';

class SearchResultsPage extends StatefulWidget {
  final String keyword;

  const SearchResultsPage({super.key, required this.keyword});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  List<SearchResultModel>? _results;
  bool _isLoading = true;
  String? _error;
  static const baseImageUrl = Urls.serviceProviderbaseUrl;

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.keyword);
    _performSearch(widget.keyword);
  }

  Future<void> _performSearch(String keyword) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ApiSearch.search(keyword);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
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
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppStrings.searchResults),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: media.width * 0.04,
          vertical: media.height * 0.015,
        ),
        child: Column(
          children: [
            // ✅ شريط البحث
            SizedBox(
              height: media.height * 0.055,
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _performSearch(value.trim());
                  }
                },
                style: TextStyle(fontSize: media.width * 0.035),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: media.width * 0.04,
                    vertical: 0,
                  ),
                  hintText: AppStrings.searchHint,
                  prefixIcon: InkWell(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        _performSearch(_controller.text.trim());
                      }
                    },
                    child: Icon(Icons.search, size: media.width * 0.05),
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
            ),
            SizedBox(height: media.height * 0.02),

            // ✅ محتوى نتائج البحث
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Center(child: Text('${AppStrings.error}: $_error'))
            else if (_results == null || _results!.isEmpty)
              const Center(child: Text(AppStrings.noResults))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _results!.length,
                itemBuilder: (context, index) {
                  final result = _results![index];
                  return InkWell(
                    onTap: () {
                      final type = result.type.toLowerCase();

                      if (type == 'product') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ProductDetailsView(
                                  productId: int.parse(result.id),
                                ),
                          ),
                        );
                      } else if (type == 'subcategory') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => SubCategoryScreen(
                                  selectedSubCategoryIndex: int.parse(
                                    result.id,
                                  ),
                                  selectedCategoryIndex: result.categoryId!,
                                ),
                          ),
                        );
                      } else if (type == 'category') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ServiceOrderScreen(),
                          ),
                        );
                      } else if (type == 'vendor') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VendorProfile(id: result.id),
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        vertical: media.height * 0.012,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: media.width * 0.03,
                          vertical: media.height * 0.015,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (result.imageUrl != null &&
                                result.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "$baseImageUrl${result.imageUrl!}",
                                  height: media.height * 0.25,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://cdn-icons-png.flaticon.com/512/13434/13434972.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              )
                            else
                              Container(
                                height: media.height * 0.25,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: media.width * 0.13,
                                  ),
                                ),
                              ),
                            SizedBox(height: media.height * 0.01),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    result.nameAr ?? AppStrings.noName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: media.width * 0.04,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (result.type.toLowerCase() == "product")
                                  Text(
                                    result.price != null
                                        ? "${AppStrings.currency} ${result.price!.toStringAsFixed(2)}"
                                        : "",
                                    style: TextStyle(
                                      fontSize: media.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: media.height * 0.005),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    result.categoryNameAr ??
                                        AppStrings.noCategory,
                                    style: TextStyle(
                                      fontSize: media.width * 0.032,
                                      color: Colors.grey[700],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (result.businessName != null &&
                                    result.businessName!.isNotEmpty)
                                  Text(
                                    result.businessName!,
                                    style: TextStyle(
                                      fontSize: media.width * 0.032,
                                      color: Colors.black54,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
