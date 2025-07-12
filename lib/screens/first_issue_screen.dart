// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/widgets/complaint_list.dart';
import 'package:citio/core/widgets/rated_complaint_list.dart';
import 'package:citio/core/widgets/new_tab_item.dart';
import 'package:citio/main.dart';
import 'package:citio/models/issue.dart';
import 'package:citio/screens/add_issue_screen.dart';
import 'package:citio/services/get_issues.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  double wp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.width * (percentage / 100);

  double hp(BuildContext context, double percentage) =>
      MediaQuery.of(context).size.height * (percentage / 100);

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
            content: Text(AppStrings.serverError),
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
                color: MyColors.black,
                size: wp(context, 5.5), // تقريبا 22.sp
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
                  AppStrings.issues,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: wp(context, 6), // تقريباً 24.sp
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
                        height: hp(context, 0.15), // 1.h تقريبا
                        thickness: hp(context, 0.1), // 0.6.h تقريباً
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: wp(context, 1.5), // 5.w
                          vertical: hp(context, 1), // 5.h
                        ),
                        child: TabBar(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          isScrollable: false,
                          indicatorSize: TabBarIndicatorSize.label,
                          dividerColor: MyColors.white,
                          indicatorColor: MyColors.primary,
                          labelColor: MyColors.primary,
                          unselectedLabelColor: MyColors.gray,
                          tabs: [
                            TabItem(
                              title: AppStrings.active,
                              count: active.length,
                            ),
                            TabItem(
                              title: AppStrings.inReview,
                              count: inprogress.length,
                            ),
                            TabItem(
                              title: AppStrings.accepted,
                              count: resolved.length,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: hp(context, 0.15), // 1.h
                        thickness: hp(context, 0.1), // 0.5.h
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
            backgroundColor: MyColors.primary,
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
            child: Icon(Icons.add, size: wp(context, 4.5), color: Colors.white),
          ),
        ),
      ),
    );
  }
}
