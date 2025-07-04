// ignore_for_file: unused_element

import 'package:citio/core/widgets/tab_bar_view.dart';
import 'package:citio/core/widgets/tab_item.dart';
import 'package:citio/main.dart';

import 'package:citio/screens/government_services.dart';

import 'package:flutter/material.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        backgroundColor: MyColors.offWhite,
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
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
          child: Icon(Icons.add, color: MyColors.white, size: 30.sp),
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
          toolbarHeight: 70.h,
          backgroundColor: MyColors.white,

          title: Padding(
            padding: EdgeInsets.fromLTRB(0.w, 12.h, 0.w, 12.h),
            child: Text(
              'طلباتي الحكومية',
              style: TextStyle(color: MyColors.black, fontSize: 20.sp),
            ),
          ),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40.h),
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
                    padding: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
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
                      TabItem(title: 'المٌعدلة'),
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
            TabBarViewItem(title: 'Edited'),
          ],
        ),
      ),
    );
  }
}
