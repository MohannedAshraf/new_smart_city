import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/tab_item.dart';
import 'package:city/models/issue.dart';
import 'package:city/screens/add_issue_screen.dart';
import 'package:city/services/get_issues.dart';
import 'package:flutter/material.dart';

String _baseUrl = 'https://cms-reporting.runasp.net/';

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
              for (int i = 0; i < issues.length; i++) {
                if (issues[i].status == 'Resolved') {
                  resolved.add(issues[i]);
                } else if (issues[i].status == 'Active') {
                  active.add(issues[i]);
                } else {
                  inprogress.add(issues[i]);
                }
              }
              return TabBarView(
                children: [
                  ComplaintList(issues: resolved), // مقبولة
                  ComplaintList(issues: resolved), // نشطة
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
        return Card(
          color: MyColors.white,
          shadowColor: MyColors.white,
          surfaceTintColor: MyColors.white,

          child: Container(
            padding: const EdgeInsets.fromLTRB(7, 7, 7, 7),
            height: 100,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    issues[index].image != null
                        ? Image.network(
                          _baseUrl + issues[index].image!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey[200],
                              child: Icon(Icons.person, size: 30),
                            );
                          },
                        )
                        : Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[200],
                          child: Icon(Icons.person, size: 30),
                        ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 15, 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              softWrap:
                                  true, // Default is true (enables line breaks)
                              overflow: TextOverflow.visible,
                              issues[index].title,
                              style: const TextStyle(
                                color: MyColors.fontcolor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // SizedBox(width: 160),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Wrap(
                                children: [
                                  Text(
                                    softWrap: true,
                                    maxLines: 3,
                                    issues[index].description ?? 'No details',
                                    style: const TextStyle(
                                      color: MyColors.fontcolor,
                                      fontSize: 12,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
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
