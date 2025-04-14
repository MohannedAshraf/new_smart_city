import 'package:city/core/widgets/tab_bar_view.dart';
import 'package:city/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/tab_item.dart';

class GovernmentScreen extends StatelessWidget {
  const GovernmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: GestureDetector(
          onTap: () {
<<<<<<< HEAD
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Image Clicked!')));
=======
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Image Clicked!')));
>>>>>>> 7890ee5142d3fccbef3ddee2f2f3de39f2520121
          },
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: MyColors.themecolor,
            child: CircleAvatar(
<<<<<<< HEAD
              backgroundImage: AssetImage('assets/image/logo1.png'),
=======
              backgroundImage: AssetImage('images/logo1.png'),
>>>>>>> 7890ee5142d3fccbef3ddee2f2f3de39f2520121
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
<<<<<<< HEAD
                color: MyColors.cardcolor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              labelColor: MyColors.cardfontcolor,
              unselectedLabelColor: Colors.black,
              tabs: [
                TabItem(title: S.of(context).resolved),
                TabItem(title: S.of(context).underreview),
                TabItem(title: S.of(context).rejected),
=======
                  color: MyColors.cardcolor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              labelColor: MyColors.cardfontcolor,
              unselectedLabelColor: Colors.black,
              tabs: [
                TabItem(
                  title: S.of(context).resolved,
                ),
                TabItem(
                  title: S.of(context).underreview,
                ),
                TabItem(
                  title: S.of(context).rejected,
                ),
>>>>>>> 7890ee5142d3fccbef3ddee2f2f3de39f2520121
              ],
            ),
          ),
        ),
<<<<<<< HEAD
        body: const TabBarView(
          children: [
            TabBarViewItem(title: 'Completed'),
            TabBarViewItem(title: 'Pending'),
            TabBarViewItem(title: 'Rejected'),
          ],
        ),
=======
        body: const TabBarView(children: [
          TabBarViewItem(
            title: 'Completed',
          ),
          TabBarViewItem(
            title: 'Pending',
          ),
          TabBarViewItem(
            title: 'Rejected',
          )
        ]),
>>>>>>> 7890ee5142d3fccbef3ddee2f2f3de39f2520121
      ),
    );
  }
}
