import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(
      text: 'أحمد محمود',
    );
    final TextEditingController phoneController = TextEditingController(
      text: '0123456789',
    );
    final TextEditingController emailController = TextEditingController(
      text: 'ahmed@email.com',
    );
    final TextEditingController addressController = TextEditingController(
      text: 'الزقازيق - الشرقية',
    );
    final TextEditingController buildingController = TextEditingController(
      text: '15',
    );
    final TextEditingController floorController = TextEditingController(
      text: '3',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('تعديل البيانات'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildTextField('الاسم بالكامل', nameController),
            buildTextField('رقم التليفون', phoneController),
            buildTextField('البريد الإلكتروني', emailController),
            buildTextField('العنوان', addressController),
            buildTextField('رقم المبنى', buildingController),
            buildTextField('رقم الدور', floorController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.blue,
                    ),
                    child: TextButton(
                      onPressed: () {
                        // تنفيذ حفظ البيانات
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'حفظ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
