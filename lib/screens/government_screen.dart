import 'package:citio/core/widgets/tab_bar_view.dart';
import 'package:citio/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/tab_item.dart';

class GovernmentScreen extends StatelessWidget {
  const GovernmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Image Clicked!')));
          },
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: MyColors.themecolor,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/image/logo1.png'),
              radius: 50,
            ),
          ),
        ),
        appBar: AppBar(
          title: Container(
            //margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            // color: Colors.grey.withOpacity(0.3),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: const BoxDecoration(
                color: MyColors.cardcolor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelColor: MyColors.cardfontcolor,
              unselectedLabelColor: Colors.black,
              tabs: [
                TabItem(title: S.of(context).resolved),
                TabItem(title: S.of(context).underreview),
                TabItem(title: S.of(context).rejected),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            TabBarViewItem(title: 'Completed'),
            TabBarViewItem(title: 'Pending'),
            TabBarViewItem(title: 'Rejected'),
          ],
        ),
      ),
    );
  }
}
