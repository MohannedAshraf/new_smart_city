import 'package:citio/core/widgets/tab_bar_view.dart';
import 'package:citio/core/widgets/tab_item.dart';
import 'package:citio/main.dart';
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: MyColors.offWhite,

        appBar: AppBar(
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

          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: Column(
              children: [
                Divider(color: MyColors.whiteSmoke, thickness: 2, height: 3),
                TabBar(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: MyColors.white,
                  indicatorColor: MyColors.inProgress,
                  labelColor: MyColors.inProgress,
                  unselectedLabelColor: MyColors.gray,
                  tabs: [
                    TabItem(title: 'الجميع'),
                    TabItem(title: 'تم حلها'),
                    TabItem(title: 'تحت المراجعة'),
                    TabItem(title: 'المرفوضة'),
                  ],
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
