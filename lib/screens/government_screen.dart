// ignore_for_file: unused_element

import 'package:citio/core/widgets/tab_bar_view.dart';
import 'package:citio/core/widgets/tab_item.dart';
import 'package:citio/main.dart';
import 'package:citio/screens/all_vendors_screen.dart';
import 'package:citio/screens/first_issue_screen.dart';
import 'package:citio/screens/government_services.dart';
import 'package:citio/screens/my_order_page.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:citio/screens/profile.dart';
import 'package:citio/screens/social_media.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/variables.dart';

class GovernmentScreen extends StatefulWidget {
  const GovernmentScreen({super.key});

  @override
  State<GovernmentScreen> createState() => _GovernmentScreenState();
}

class _GovernmentScreenState extends State<GovernmentScreen> {
  DateTime? lastBackPressTime;

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اضغط مرة أخرى للخروج'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: MyColors.offWhite,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: MyColors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'مدينتنا',
                      style: TextStyle(
                        color: MyColors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'مرحباً بكم!',
                      style: TextStyle(color: MyColors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('الرئيسية'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(initialIndex: 0),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_police_rounded),
                title: const Text('حكومتنا'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(initialIndex: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.report),
                title: const Text('المشاكل'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IssueScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.online_prediction),
                title: const Text('لطلب الخدمات'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(initialIndex: 3),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.groups_outlined),
                title: const Text('وسائل التواصل الاجتماعي'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomePage(initialIndex: 2),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_basket_outlined),
                title: const Text('البائعين'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllVendorsScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.receipt_long_outlined),
                title: const Text('طلباتي'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyOrdersPage(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('الملف الشخصي'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('تسجيل الخروج'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyloginPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        backgroundColor: MyColors.offWhite,
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GovernmentServices(),
              ),
            );
          },
          backgroundColor: MyColors.dodgerBlue,
          child: const Icon(Icons.add, color: MyColors.white, size: 30),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: MyColors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(initialIndex: 0),
                ),
              );
            },
          ),
          //flexibleSpace: Container(height: 0),
          toolbarHeight: 70,
          backgroundColor: MyColors.white,

          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Text(
              'طلباتي',
              style: TextStyle(color: MyColors.black, fontSize: 20),
            ),
          ),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Column(
              children: [
                const Divider(
                  color: MyColors.whiteSmoke,
                  thickness: 2,
                  height: 3,
                ),
                Transform.translate(
                  offset: Offset(screenWidth * .12, 0),
                  child: TabBar(
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: MyColors.white,
                    indicatorColor: MyColors.inProgress,
                    labelColor: MyColors.inProgress,
                    unselectedLabelColor: MyColors.gray,
                    tabs: const [
                      TabItem(title: 'الجميع'),
                      TabItem(title: 'تم حلها'),
                      TabItem(title: 'تحت المراجعة'),
                      TabItem(title: 'المرفوضة'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: const TabBarView(
          children: [
            TabBarViewItem(title: 'الجميع'),
            TabBarViewItem(title: 'Completed'),
            TabBarViewItem(title: 'Pending'),
            TabBarViewItem(title: 'Rejected'),
          ],
        ),
      ),
    );
  }
}
