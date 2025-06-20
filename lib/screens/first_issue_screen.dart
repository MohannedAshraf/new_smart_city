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
      inprogress =
          issues
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.report_problem, color: MyColors.themecolor, size: 22),
              SizedBox(width: 6),
              Text(
                'المشاكل',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          centerTitle: true,
          elevation: 0,
        ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    const Divider(
                      height: 1,
                      thickness: 0.6,
                      color: Colors.black12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: TabBar(
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 2.5,
                            color: MyColors.themecolor,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        labelColor: MyColors.themecolor,
                        unselectedLabelColor: Colors.black,

                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),

                        tabs: [
                          TabItem(title: 'نشطة', count: active.length),
                          TabItem(
                            title: 'تحت المراجعة',
                            count: inprogress.length,
                          ),
                          TabItem(title: 'المقبولة', count: resolved.length),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Colors.black12,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ComplaintList(issues: active, type: 'active'),
                          ComplaintList(issues: inprogress, type: 'inprogress'),
                          RatedComplaintList(issues: resolved),
                        ],
                      ),
                    ),
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
