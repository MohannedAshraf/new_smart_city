import 'package:flutter/material.dart';

class ServiceOrderScreen extends StatefulWidget {
  const ServiceOrderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ServiceOrderScreenState createState() => _ServiceOrderScreenState();
}

class _ServiceOrderScreenState extends State<ServiceOrderScreen> {
  final List<Map<String, String>> allServices = [
    {'name': 'مطعم النيل', 'category': 'مطاعم'},
    {'name': 'مطعم الشامي', 'category': 'مطاعم'},
    {'name': 'مطعم الكرنك', 'category': 'مطاعم'},
    {'name': 'سوبر ماركت الأمل', 'category': 'سوبرماركت'},
    {'name': 'سوبر ماركت السعادة', 'category': 'سوبرماركت'},
    {'name': 'سوبر ماركت الهدى', 'category': 'سوبرماركت'},
    {'name': 'محل ملابس الربيع', 'category': 'محلات ملابس'},
    {'name': 'محل ملابس أناقة', 'category': 'محلات ملابس'},
    {'name': 'محل ملابس المستقبل', 'category': 'محلات ملابس'},
    {'name': 'السباك الماهر', 'category': 'سباكين'},
    {'name': 'سباك الشرق', 'category': 'سباكين'},
    {'name': 'سباك المصري', 'category': 'سباكين'},
    {'name': 'كهربائي النور', 'category': 'كهربائيين'},
    {'name': 'كهربائي الإنارة', 'category': 'كهربائيين'},
    {'name': 'كهربائي الطليعة', 'category': 'كهربائيين'},
    {'name': 'نجار المستقبل', 'category': 'نجارين'},
    {'name': 'نجار الخشب', 'category': 'نجارين'},
    {'name': 'نجار الفن', 'category': 'نجارين'},
    {'name': 'جزارة البركة', 'category': 'محلات جزارة'},
    {'name': 'جزارة الفلاح', 'category': 'محلات جزارة'},
    {'name': 'صيدلية الشفاء', 'category': 'صيدليات'},
    {'name': 'صيدلية الرحمة', 'category': 'صيدليات'},
    {'name': 'القوة', 'category': 'صالة ألعاب رياضية'},
    {'name': 'اللياقة', 'category': 'صالة ألعاب رياضية'},
  ];

  final Map<String, IconData> categoryIcons = {
    'مطاعم': Icons.restaurant,
    'سوبرماركت': Icons.local_grocery_store,
    'محلات ملابس': Icons.checkroom,
    'سباكين': Icons.plumbing,
    'كهربائيين': Icons.electrical_services,
    'نجارين': Icons.handyman,
    'محلات جزارة': Icons.storefront,
    'صيدليات': Icons.local_pharmacy,
    'صالة ألعاب رياضية': Icons.fitness_center,
  };

  List<Map<String, String>> displayedServices = [];
  String searchQuery = '';
  List<String> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    displayedServices = allServices;
  }

  void filterServices() {
    setState(() {
      displayedServices = allServices.where((service) {
        final matchesSearch = service['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase().trim());
        final matchesCategory = selectedCategories.isEmpty ||
            selectedCategories.contains(service['category']);
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void showFilterDialog() {
    List<String> tempSelectedCategories = List.from(selectedCategories);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('تصفية حسب الفئة',
                  textDirection: TextDirection.rtl),
              content: SingleChildScrollView(
                child: Column(
                  children: categoryIcons.keys.map((category) {
                    return CheckboxListTile(
                      title: Text(category, textDirection: TextDirection.rtl),
                      value: tempSelectedCategories.contains(category),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            tempSelectedCategories.add(category);
                          } else {
                            tempSelectedCategories.remove(category);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategories = tempSelectedCategories;
                      filterServices();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('تطبيق'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الخدمة', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      searchQuery = value;
                      filterServices();
                    },
                    decoration: InputDecoration(
                      hintText: 'ابحث عن خدمة...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: showFilterDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                ),
                itemCount: displayedServices.length,
                itemBuilder: (context, index) {
                  final service = displayedServices[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            categoryIcons[service['category']] ?? Icons.store,
                            size: 40,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(height: 8),
                          Text(service['name']!, textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
