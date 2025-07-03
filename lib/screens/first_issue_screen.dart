// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/complaint_list.dart';
import 'package:citio/core/widgets/rated_complaint_list.dart';
import 'package:citio/core/widgets/new_tab_item.dart';
import 'package:citio/main.dart';
import 'package:citio/models/issue.dart';
import 'package:citio/screens/add_issue_screen.dart';
import 'package:citio/services/get_issues.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅

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
    try {
      final data = await GetIssues().getIssues();
      final issues = data.values;

      issues.sort((a, b) {
        try {
          final fixedA = a.date.replaceAllMapped(
            RegExp(r'([a-zA-Z]+ \d{1,2}),(\d{4})'),
            (match) => '${match[1]}, ${match[2]}',
          );
          final fixedB = b.date.replaceAllMapped(
            RegExp(r'([a-zA-Z]+ \d{1,2}),(\d{4})'),
            (match) => '${match[1]}, ${match[2]}',
          );
          final dateA = DateFormat(
            "MMMM d, yyyy h:mm a",
            "en_US",
          ).parse(fixedA);
          final dateB = DateFormat(
            "MMMM d, yyyy h:mm a",
            "en_US",
          ).parse(fixedB);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });

      setState(() {
        active = issues.where((e) => e.status == 'Active').toList();
        resolved = issues.where((e) => e.status == 'Resolved').toList();
        inprogress =
            issues
                .where((e) => e.status != 'Active' && e.status != 'Resolved')
                .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('❌ Error loading issues: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("🚨 حدثت مشكلة في السيرفر. هيتم حلها في أقرب وقت."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: MyColors.themecolor,
                size: 22.sp,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'المشاكل',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
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
                      Divider(
                        height: 1.h,
                        thickness: 0.6.h,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 5.h,
                        ),
                        child: TabBar(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: MyColors.white,
                          indicatorColor: MyColors.inProgress,
                          labelColor: MyColors.inProgress,
                          unselectedLabelColor: MyColors.gray,
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
                      Divider(
                        height: 1.h,
                        thickness: 0.5.h,
                        color: Colors.black12,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ComplaintList(issues: active, type: 'active'),
                            ComplaintList(
                              issues: inprogress,
                              type: 'inprogress',
                            ),
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
              ).then((_) {
                loadIssues();
              });
            },
            child: Icon(Icons.add, size: 20.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
