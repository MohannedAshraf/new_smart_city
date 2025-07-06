// ignore_for_file: unused_element

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/widgets/tab_bar_view.dart';
import 'package:citio/core/widgets/tab_item.dart';
import 'package:citio/main.dart';

import 'package:citio/screens/government_services.dart';

import 'package:flutter/material.dart';

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
          content: Text(AppStrings.pressAgainToExit),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  double wp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  double hp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: MyColors.white,
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              wp(context, 7.5),
            ), // 30.r approx
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GovernmentServices(),
              ),
            );
          },
          backgroundColor: MyColors.primary,
          child: Icon(
            Icons.add,
            color: MyColors.white,
            size: wp(context, 7.5),
          ), // 30.sp approx
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
          toolbarHeight: hp(context, 9), // 70.h approx
          backgroundColor: MyColors.white,
          title: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              hp(context, 1.5),
              0,
              hp(context, 1.5),
            ),
            child: Text(
              AppStrings.myGovernmentRequests,
              style: TextStyle(color: MyColors.black, fontSize: wp(context, 5)),
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(hp(context, 5)), // 40.h approx
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
                    padding: EdgeInsets.symmetric(horizontal: wp(context, 2.5)),
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: MyColors.white,
                    indicatorColor: MyColors.primary,
                    labelColor: MyColors.primary,
                    unselectedLabelColor: MyColors.gray,
                    tabs: const [
                      TabItem(title: AppStrings.all),
                      TabItem(title: AppStrings.completed),
                      TabItem(title: AppStrings.pending),
                      TabItem(title: AppStrings.rejected),
                      TabItem(title: AppStrings.edited),
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
