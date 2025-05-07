import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/widgets/tab_item.dart';
import 'package:citio/models/issue.dart';
import 'package:citio/screens/add_issue_screen.dart';
import 'package:citio/services/get_issues.dart';
import 'package:flutter/material.dart';

String _baseUrl = 'https://cms-reporting.runasp.net/';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
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
              TabItem(title: 'نشطة'),
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
              for (var issue in issues) {
                if (issue.status == 'Resolved') {
                  resolved.add(issue);
                } else if (issue.status == 'Active') {
                  active.add(issue);
                } else {
                  inprogress.add(issue);
                }
              }
              return TabBarView(
                children: [
                  ComplaintList(issues: resolved),
                  ComplaintList(issues: active),
                  ComplaintList(issues: inprogress),
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
      itemCount: issues.length,
      itemBuilder: (context, index) {
        return Card(
          color: MyColors.white,
          shadowColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ الصورة
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child:
                        issues[index].image != null
                            ? Image.network(
                              _baseUrl + issues[index].image!,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image, size: 30);
                              },
                            )
                            : const Icon(Icons.person, size: 30),
                  ),
                ),

                const SizedBox(width: 12), // مسافة بين الصورة والنص
                // ✅ النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        issues[index].title,
                        style: const TextStyle(
                          color: MyColors.fontcolor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        issues[index].description ?? 'No details',
                        style: const TextStyle(
                          color: MyColors.fontcolor,
                          fontSize: 12,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // ✅ التاريخ
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      issues[index].date,
                      style: const TextStyle(
                        color: Color.fromRGBO(134, 133, 133, 1),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
