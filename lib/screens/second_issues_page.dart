import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/tab_item.dart';
import 'package:city/models/issue.dart';
import 'package:city/screens/add_issue_screen.dart';
import 'package:city/services/get_issues.dart';
import 'package:flutter/material.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التابات
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          backgroundColor: MyColors.backgroundColor,
          automaticallyImplyLeading: false,
          title: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'المشاكل',
              style: TextStyle(color: MyColors.themecolor, fontSize: 20),
            ),
          ),
          centerTitle: true,

          elevation: 0,
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
              TabItem(title: 'المقبولة'),
              TabItem(title: 'المرفوضة'),
              TabItem(title: 'تحت المراجعة'),
            ],
          ),
        ),
        body: FutureBuilder<Issue>(
          future: GetIssues().getIssues(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Values> issues = snapshot.data!.values;
              List<Values> active = [];
              List<Values> resolved = [];
              List<Values> inprogress = [];
              for (int i = 0; i < issues.length; i++) {
                if (issues[i].title == 'Active') {
                  active.add(issues[i]);
                } else if (issues[i].title == 'InProgress') {
                  inprogress.add(issues[i]);
                } else {
                  resolved.add(issues[i]);
                }
              }
              return TabBarView(
                children: [
                  ComplaintList(issues: active), // مقبولة
                  ComplaintList(issues: resolved), // مرفوضة
                  ComplaintList(issues: inprogress), // تحت المراجعة
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NewComplaintCenterPage(),
              ),
            );
          },
          child: const Icon(Icons.add, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class ComplaintList extends StatelessWidget {
  final List<Values> issues;
  const ComplaintList({super.key, required this.issues});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: issues.length, // عدد العناصر
      itemBuilder: (context, index) {
        return const Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text('شكوى سباكه'),
            subtitle: Row(
              children: [
                Text('حالة'),
                SizedBox(width: 10),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.75, // نسبة التقدم لو عايز
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
