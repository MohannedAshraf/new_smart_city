import 'package:city/screens/add_issue_screen.dart';
import 'package:flutter/material.dart';

class IssuesPage extends StatelessWidget {
  const IssuesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // عدد التابات
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المشاكل "),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              color: Colors.green, // لون التاب المختار
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: const [
              Tab(text: 'مقبولة'),
              Tab(text: 'مرفوضة'),
              Tab(text: 'تحت المراجعة'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ComplaintList(), // مقبولة
            ComplaintList(), // مرفوضة
            ComplaintList(), // تحت المراجعة
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => NewComplaintCenterPage()),
            );
          },
          child: const Icon(Icons.add, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

class ComplaintList extends StatelessWidget {
  const ComplaintList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // عدد العناصر
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
