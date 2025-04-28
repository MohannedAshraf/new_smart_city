import 'package:city/core/utils/variables.dart';

import 'package:city/core/widgets/socialmedia_tab_view.dart';
import 'package:city/core/widgets/socilamedia_profile.dart';

import 'package:city/core/widgets/tab_item.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://x.com/home');

class SocialMedia extends StatefulWidget {
  const SocialMedia({super.key});

  @override
  _SocialMediaState createState() => _SocialMediaState();
}

class _SocialMediaState extends State<SocialMedia> {
  //const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed:
              () => showDialog<String>(
                context: context,
                builder:
                    (BuildContext context) => AlertDialog(
                      title: const Text('سيتم تحويلك خارج  citio'),
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
          backgroundColor: MyColors.cardcolor,
          label: const Text(
            maxLines: 1,
            textAlign: TextAlign.center,
            'Show all',
            style: TextStyle(fontSize: 18, color: MyColors.fontcolor),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Icon(
            Icons.groups_2_outlined,
            color: MyColors.themecolor,
          ),
          centerTitle: true,
          //  excludeHeaderSemantics: true,
          backgroundColor: MyColors.white,
          bottom: const TabBar(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: MyColors.themecolor,
            indicatorColor: MyColors.themecolor,
            labelColor: MyColors.fontcolor,
            unselectedLabelColor: Colors.black,
            tabs: [TabItem(title: 'Feed'), TabItem(title: 'Profile')],
          ),
        ),
        body: TabBarView(
          children: [SocialmediaTabView(), SocialmediaProfile()],
        ),
      ),
    );
  }
}
