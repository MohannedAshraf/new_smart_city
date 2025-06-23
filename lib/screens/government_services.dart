// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:citio/screens/government_service_details.dart';
import 'package:flutter/material.dart';

class GovernmentServices extends StatefulWidget {
  const GovernmentServices({super.key});
  @override
  _GovernmentServicesState createState() => _GovernmentServicesState();
}

class _GovernmentServicesState extends State<GovernmentServices> {
  int selectedIndex = 0;
  final Map<String, Map<String, dynamic>> govTabStyles = {
    'السجل المدني': {
      'color': Color(0x1A607D8B),
      'icon': Icons.badge,
      'fontColor': Colors.blueGrey,
    },
    'النقل': {
      'color': Colors.orange.withOpacity(0.1),
      'icon': Icons.directions_bus,
      'fontColor': Colors.orange,
    },
    'الصحة': {
      'color': Colors.redAccent.withOpacity(0.1),
      'icon': Icons.local_hospital,
      'fontColor': Colors.redAccent,
    },
    'المالية': {
      'color': Colors.green.withOpacity(0.1),
      'icon': Icons.attach_money,
      'fontColor': Colors.green,
    },
    'التجارة': {
      'color': Colors.deepPurple.withOpacity(0.1),
      'icon': Icons.shopping_cart,
      'fontColor': Colors.deepPurple,
    },
  };
  final List<Map<String, dynamic>> serviceList = [
    {
      'icon': Icons.local_hospital,
      'color': Colors.redAccent.withOpacity(.1),
      'fontColor': Colors.red,
      'category': 'صحة',
      'serviceName': 'حجز موعد تطعيم',
      'details': 'خدمة لحجز مواعيد التطعيم للأطفال في المراكز الصحية.',
    },
    {
      'icon': Icons.badge,
      'color': Colors.blueGrey.withOpacity(0.1),
      'fontColor': Colors.blueGrey,
      'category': 'السجل المدني',
      'serviceName': 'توثيق عقد زواج',
      'details': 'خدمة التوثيق الإلكتروني لعقود الزواج المدنية.',
    },

    {
      'icon': Icons.description,
      'color': Colors.orange.withOpacity(0.1),
      'fontColor': Colors.orange,
      'category': 'النقل',
      'serviceName': 'تجديد رخصة قيادة',
      'details': 'خدمة إلكترونية لتجديد رخص القيادة للمواطنين والمقيمين.',
    },
    {
      'icon': Icons.local_hospital,
      'color': Colors.redAccent.withOpacity(.1),
      'fontColor': Colors.red,
      'category': 'صحة',
      'serviceName': 'حجز موعد تطعيم',
      'details': 'خدمة لحجز مواعيد التطعيم للأطفال في المراكز الصحية.',
    },
    {
      'icon': Icons.attach_money,
      'color': Colors.green.withOpacity(0.1),
      'fontColor': Colors.green,
      'category': 'المالية',
      'serviceName': 'توثيق عقد زواج',
      'details': 'خدمة التوثيق الإلكتروني لعقود الزواج المدنية.',
    },
    {
      'icon': Icons.account_balance,
      'color': Colors.deepPurple.withOpacity(0.1),
      'fontColor': Colors.deepPurple,
      'category': ' التجارة',
      'serviceName': 'طلب بطاقة تموين',
      'details': 'خدمة إصدار أو تجديد بطاقة التموين عبر الإنترنت.',
    },
  ];

  final List<String> tabs = [
    'الكل',
    'السجل المدني',
    'النقل ',
    'الصحة',
    'المالية',
    'التجارة',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            'الخدمات الحكومية',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 19, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: CustomSearchBar(
                            height: 45,
                            borderRadius: 5,
                            hintText: 'للبحث عن خدمة حكومية',
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: MyColors.whiteSmoke,
                              ),
                              margin: const EdgeInsets.all(8),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: MyColors.gray,
                                ),
                              ),
                            ),
                            // const SizedBox(height: 0),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                      child: Row(
                        children: List.generate(tabs.length, (index) {
                          return GovTabItem(
                            title: tabs[index],
                            isSelected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              //'مكان الfunction التانية يا لولو'
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                    childAspectRatio: 158 / 250,
                    //childAspectRatio: 0.60869,
                  ),
                  itemCount: serviceList.length,
                  itemBuilder: (context, index) {
                    final service = serviceList[index];
                    return ServiceCard(
                      ontab:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GovernmentServiceDetails(),
                            ),
                          ),
                      icon: service['icon'],
                      color: service['color'],
                      fontColor: service['fontColor'],
                      category: service['category'],
                      serviceName: service['serviceName'],
                      details: service['details'],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GovTabItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final bool isSelected;

  const GovTabItem({
    super.key,
    required this.title,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MyColors.dodgerBlue : MyColors.whiteSmoke,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(color: isSelected ? MyColors.white : MyColors.black),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color fontColor;
  final String category;
  final String serviceName;
  final String details;
  final VoidCallback ontab;
  const ServiceCard({
    super.key,
    required this.icon,
    required this.color,
    required this.category,
    required this.serviceName,
    required this.fontColor,
    required this.details,
    required this.ontab,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontab,
      child: Container(
        width: double.infinity,
        //height: 230,
        margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),

        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: const [
            BoxShadow(
              color: MyColors.whiteSmoke,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                color: color,

                width: double.infinity,
                height: 130,
                child: Center(child: Icon(icon, size: 40, color: fontColor)),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(6, 0, 6, 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(category, style: TextStyle(color: fontColor)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 1,
                      serviceName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                      //maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      maxLines: 2,
                      details,
                      style: const TextStyle(
                        color: Color.fromARGB(221, 59, 58, 58),
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
