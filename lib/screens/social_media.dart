import 'package:city/core/utils/variables.dart';
import 'package:city/core/widgets/tab_bar_view.dart';
import 'package:city/core/widgets/tab_item.dart';
import 'package:city/generated/l10n.dart';
import 'package:flutter/material.dart';

class SocilaMedia extends StatelessWidget {
  const SocilaMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Social Media', textAlign: TextAlign.center)],
          ),
          //  excludeHeaderSemantics: true,
          backgroundColor: Colors.grey.withOpacity(0.3),
          bottom: TabBar(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicatorColor: MyColors.themecolor,
            labelColor: MyColors.fontcolor,
            unselectedLabelColor: Colors.black,
            tabs: [
              TabItem(title: 'الأكثر رواجا'),
              TabItem(title: 'الأحدث'),
              TabItem(title: 'الأشخاص'),
              TabItem(title: 'الوسائط'),
              TabItem(title: 'الأخبار'),
              TabItem(title: 'الرياضة'),
              TabItem(title: 'Entertainment'),
            ],
          ),
        ),
        body: Text('data'),
      ),
    );
  }
}
