import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/new_tab_item.dart';
import 'package:city/main.dart';
import 'package:city/models/issue.dart';
import 'package:city/screens/add_issue_screen.dart';
import 'package:city/services/get_issues.dart';
import 'package:city/core/widgets/complaint_list.dart';
import 'package:city/core/widgets/rated_complaint_list.dart';
import 'package:flutter/material.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  List<Values> active = [];
  List<Values> resolved = [];
  List<Values> inprogress = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadIssues();
  }

  Future<void> loadIssues() async {
    final data = await GetIssues().getIssues();
    final issues = data.values;

    setState(() {
      active = issues.where((e) => e.status == 'Active').toList();
      resolved = issues.where((e) => e.status == 'Resolved').toList();
      inprogress = issues
          .where((e) => e.status != 'Active' && e.status != 'Resolved')
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 35,
          backgroundColor: MyColors.backgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: MyColors.themecolor),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          title: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.report_problem, color: MyColors.themecolor),
                SizedBox(width: 8),
                Text(
                  'المشاكل',
                  style: TextStyle(color: MyColors.themecolor, fontSize: 20),
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            splashBorderRadius: const BorderRadius.all(Radius.circular(10)),
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            indicator: const BoxDecoration(
              color: MyColors.cardcolor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            labelColor: MyColors.cardfontcolor,
            unselectedLabelColor: Colors.black,
            tabs: [
              TabItem(title: 'المقبولة', count: resolved.length),
              TabItem(title: 'نشطة', count: active.length),
              TabItem(title: 'تحت المراجعة', count: inprogress.length),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
             RatedComplaintList(issues: resolved),
             ComplaintList(issues: active, type: 'active'),
             ComplaintList(issues: inprogress, type: 'inprogress'),

                ],
              ),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          backgroundColor: MyColors.themecolor,
          onPressed: () {
            Navigator.push(
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
