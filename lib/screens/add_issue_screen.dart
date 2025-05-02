// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:city/core/utils/mycolors.dart';
import 'package:city/core/widgets/custom_button.dart';
import 'package:city/services/issue_report.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Map<String, String> myItems = {
  'مشاكل كهربائية': 'electrical_issues',
  'مشاكل السباكة': 'plumbing_issues',
  'إدارة النفايات': 'waste_management',
  'الطرق وحركة المرور': 'road_and_traffic',
  'السلامة العامة': 'public_safety',
  'الحدائق والترفيه': 'parks_and_recreation',
  'النقل العام': 'public_transportation',
  'القضايا البيئية': 'environmental_concerns',
  'البنية التحتية': 'infrastructure',
  '"خدمات المجتمع': 'community_services',
  'الصحة والسلامة': 'health_and_safety',
  'الأحداث العامة': 'public_events',
  'لتكنولوجيا والاتصال': 'technology_connectivity',
  'طوارئ': 'emergency',
  'متنوع': 'miscellaneous',
};

class NewComplaintCenterPage extends StatefulWidget {
  const NewComplaintCenterPage({super.key});

  @override
  _NewComplaintCenterPageState createState() => _NewComplaintCenterPageState();
}

class _NewComplaintCenterPageState extends State<NewComplaintCenterPage> {
  final TextEditingController _controller = TextEditingController();
  String? description, category, address, image;
  double? lat, long;
  String id = '440078c2-3e3a-4c26-8fb6-258671e872a';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.backgroundColor,
        centerTitle: true,
        title: const Text(
          "شكوي  جديده ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (data) {
                    description = data;
                  },
                  // controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'اكتب الشكوى هنا ....',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (data) {
                    image = data;
                  },
                  // controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'image',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          color: MyColors.white,
                          child: DropdownMenu(
                            menuStyle: MenuStyle(
                              backgroundColor: MaterialStateProperty.all(
                                MyColors.offWhite,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            menuHeight: 300,
                            enableSearch: true,
                            inputDecorationTheme: const InputDecorationTheme(
                              border: UnderlineInputBorder(),
                              fillColor: MyColors.white,
                              hoverColor: MyColors.whiteSmoke,
                            ),
                            width: screenWidth * 0.8,
                            initialSelection: 'Item1',
                            hintText: 'Select Category',
                            dropdownMenuEntries:
                                myItems.entries.map((entry) {
                                  return DropdownMenuEntry<String>(
                                    value: entry.value,
                                    label: entry.key,
                                  );
                                }).toList(),
                            onSelected: (String? value) {
                              category = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (data) {
                    lat = double.tryParse(data) ?? 0.0;
                  },
                  // controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Latitude',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (data) {
                    long = double.tryParse(data) ?? 0.0;
                  },
                  // controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'longitude.',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: screenWidth * 0.9,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.whiteSmoke),
                  borderRadius: BorderRadius.circular(20),
                  color: MyColors.white,
                ),
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  onChanged: (data) {
                    address = data.isEmpty ? " " : data;
                  },
                  // controller: _controller,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'اكتب العنوان هنا...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth * 0.9,

              padding: const EdgeInsets.all(10),
              child: MyTextButton(
                text: "Submit",
                onPressed: () {
                  try {
                    AddReport().addReport(
                      id,
                      description!,
                      category!,
                      image,
                      lat!,
                      long!,
                      address!,
                    );
                    print('Success');
                  } on Exception catch (error) {
                    print('failed');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*class Issuing extends StatelessWidget {
  final double width;
  final Function(String)? onChanged;
  final String text;
  const Issuing({
    super.key,
    required this.width,
    this.onChanged,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: MyColors.whiteSmoke),
          borderRadius: BorderRadius.circular(20),
          color: MyColors.white,
        ),
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          onChanged: onChanged,
          // controller: _controller,
          decoration: const InputDecoration(
            hintText: text,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          ),
        ),
      ),
    );
  }
}
*/
