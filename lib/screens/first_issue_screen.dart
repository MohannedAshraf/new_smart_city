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
  DateTime? lastBackPressTime;

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
      if (context.mounted) {
        // ignore: use_build_context_synchronously
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
    final now = DateTime.now();
    if (lastBackPressTime == null ||
        now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اضغط مرة أخرى للخروج'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: _onWillPop,
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
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.report_problem,
                  color: MyColors.themecolor,
                  size: 22,
                ),
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
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                      const Divider(
                        height: 1,
                        thickness: 0.5,
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
            child: const Icon(Icons.add, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
