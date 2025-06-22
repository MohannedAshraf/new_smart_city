import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/search_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/search_bar.dart';

class GovernmentServices extends StatefulWidget {
  const GovernmentServices({super.key});
  @override
  _GovernmentServicesState createState() => _GovernmentServicesState();
}

class _GovernmentServicesState extends State<GovernmentServices> {
  int selectedIndex = 0;

  final List<String> tabs = [
    'الكل',
    'قانوني',
    'الخدمات العامة',
    'الصحة',
    'التراخيص',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: MyColors.backgroundColor,
          automaticallyImplyLeading: true,
          title: const Text(
            'الخدمات الحكومية',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            Container(
              color: MyColors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 19, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: CustomSearchBar(
                            height: 55,
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
                                onPressed: () {
                                  // مثال: لما تضغط زر الفلتر
                                  print('فلتر تم الضغط عليه');
                                },
                                icon: const Icon(
                                  Icons.filter_alt,
                                  color: MyColors.gray,
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                      child: Row(
                        children: List.generate(tabs.length, (index) {
                          return GovTabItem(
                            title: tabs[index],
                            isSelected: selectedIndex == index,
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              print('مكان الfunction التانية يا لولو');
                            },
                          );
                        }),
                      ),
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
        margin: const EdgeInsets.fromLTRB(6, 0, 6, 10),
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

//class ServiceCard extends StatelessWidget{

//}
