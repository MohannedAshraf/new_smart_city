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
    'صالة ألعاب رياضية': Icons.fitness_center, // أيقونة الجيم
  };

  List<String> selectedCategories = [];
  List<Map<String, String>> displayedServices = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    displayedServices = allServices;
  }

  void filterServices() {
    setState(() {
      displayedServices = allServices.where((service) {
        final matchesCategory = selectedCategories.isEmpty ||
            selectedCategories.contains(service['category']);
        final matchesSearch = service['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase().trim());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void showFilterDialog() {
    final categories =
        allServices.map((service) => service['category']!).toSet();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title:
                  const Text('اختر الفئات', textDirection: TextDirection.rtl),
              content: SizedBox(
                height: 300, // تحديد ارتفاع يسمح بالـ Scroll
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: categories
                        .map(
                          (category) => CheckboxListTile(
                            title: Text(category,
                                textDirection: TextDirection.rtl),
                            value: selectedCategories.contains(category),
                            activeColor: Colors.blue,
                            checkColor: Colors.white,
                            onChanged: (bool? isChecked) {
                              setState(() {
                                if (isChecked ?? false) {
                                  selectedCategories.add(category);
                                } else {
                                  selectedCategories.remove(category);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    filterServices();
                  },
                  child: const Text('تطبيق'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void openServiceDetails(String serviceName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(serviceName, textDirection: TextDirection.rtl),
            centerTitle: true,
          ),
          body: Center(
            child: Text(
              'تفاصيل $serviceName',
              style: const TextStyle(fontSize: 20),
              textDirection: TextDirection.rtl,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلبات الخدمة', textDirection: TextDirection.rtl),
        automaticallyImplyLeading: false, // إزالة زر الرجوع
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
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: showFilterDialog,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: displayedServices.length,
                itemBuilder: (context, index) {
                  final service = displayedServices[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        service['name']!,
                        textDirection: TextDirection.rtl,
                      ),
                      subtitle: Text(
                        service['category']!,
                        textDirection: TextDirection.rtl,
                      ),
                      leading: Icon(categoryIcons[service['category']] ??
                          Icons.storefront),
                      onTap: () => openServiceDetails(service['name']!),
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
