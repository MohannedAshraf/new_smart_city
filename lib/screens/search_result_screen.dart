// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:citio/screens/product_details_view.dart';
import 'package:citio/screens/service_order_screen.dart';
import 'package:citio/screens/vendor_profile.dart';
import 'package:flutter/material.dart';
import 'package:citio/helper/api_search.dart';
import 'package:citio/models/search_model.dart';

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
  static const baseImageUrl = "https://service-provider.runasp.net";

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  Future<void> _performSearch() async {
    try {
      final results = await ApiSearch.search(widget.keyword);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("نتائج البحث")),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text('❌ خطأ: $_error'))
              : _results == null || _results!.isEmpty
              ? Center(child: Text("لا توجد نتائج"))
              : ListView.builder(
                itemCount: _results!.length,
                padding: const EdgeInsets.all(12),
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
                                (context) => ProductDetailsView(
                                  productId: int.parse(result.id),
                                ),
                          ),
                        );
                      } else if (type == 'subcategory') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceOrderScreen(),
                          ),
                        );
                      } else if (type == 'category') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceOrderScreen(),
                          ),
                        );
                      } else if (type == 'vendor') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VendorProfile(id: result.id),
                          ),
                        );
                      } else {
                        print("نوع غير معروف: ${result.type}");
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (result.imageUrl != null &&
                                result.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  "$baseImageUrl${result.imageUrl!}",
                                  height: 180,
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
                                height: 180,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            Text(
                              result.nameAr ?? "بدون اسم",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              result.categoryNameAr ?? "بدون تصنيف",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
