import 'package:city/core/utils/assets_image.dart';
import 'package:city/core/widgets/tab_bar_view.dart';
import 'package:city/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/tab_item.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://dribbble.com/shots/popular/mobile');

class GovernmentScreen extends StatelessWidget {
  const GovernmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: MyColors.themecolor,
        floatingActionButton: GestureDetector(
          onTap:
              () => showDialog<String>(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
                      title: const Text('سيتم تحويلك خارج تطبيق citio'),
                      content: const Text('هل أنت متأكد بأنك ترغب بالرحيل'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('الغاء'),
                        ),
                        TextButton(
                          onPressed: () {
                            launchUrl(_url, mode: LaunchMode.inAppWebView);
                          },
                          child: const Text('نعم'),
                        ),
                      ],
                    ),
              ),
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: MyColors.themecolor,
            child: CircleAvatar(
              backgroundImage: AssetImage(MyAssetsImage.logo),
              radius: 50,
            ),
          ),
        ),
        appBar: AppBar(
          //flexibleSpace: Container(height: 0),
          toolbarHeight: 30,
          backgroundColor: MyColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
            child: Text(
              'Citio',
              style: TextStyle(color: MyColors.themecolor, fontSize: 20),
            ),
          ),
          centerTitle: true,

          bottom: const TabBar(
            splashBorderRadius: BorderRadius.all(Radius.circular(10)),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: MyColors.cardcolor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelColor: MyColors.cardfontcolor,
            unselectedLabelColor: Colors.black,
            tabs: [
              TabItem(title: 'تم حلها'),
              TabItem(title: 'تحت المراجعة'),
              TabItem(title: 'المرفوضة'),
            ],
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
