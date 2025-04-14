import 'package:city/screens/government_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IssueScreenState createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  final TextEditingController _complaintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child:
                            buildButton("الشرطة", Icons.local_police_outlined)),
                    const SizedBox(width: 10),
                    Expanded(
                        child:
                            buildButton("المطافي", Icons.fire_truck_outlined)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: buildButton(
                            "الاسعاف", Icons.local_hospital_outlined)),
                  ],
                ),
                const SizedBox(height: 20),
                buildComplaintForm(),
                const SizedBox(height: 20),
                buildContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, IconData icon) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('الاتصال ب $text ')));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildComplaintForm() {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'الشكوي الجديدة!',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم تقديم الشكوى')));
                  _complaintController.clear();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF3D6643),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('تسجيل الشكوى'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchMessages() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.take(3).map((item) => item['title'] as String).toList();
    } else {
      throw Exception('فشل في تحميل الرسائل');
    }
  }

  Widget buildContainer() {
    return FutureBuilder<List<String>>(
      future: fetchMessages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('خطأ في تحميل البيانات'));
        } else if (snapshot.hasData) {
          final recentMessages = snapshot.data!;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'آخر 3 طلبات:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                for (var message in recentMessages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.messenger_outlined,
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            message,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GovernmentScreen()),
                    );
                  },
                  child: const Text(
                    'عرض جميع الشكاوي',
                    style: TextStyle(
                      color: Color(0xFF3D6643),
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('لا توجد بيانات.'));
        }
      },
    );
  }
}
