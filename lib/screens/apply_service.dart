import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ApplyService extends StatefulWidget {
  const ApplyService({super.key});
  @override
  _ApplyService createState() => _ApplyService();
}

class _ApplyService extends State<ApplyService> {
  bool isChecked = false;
  bool isButtonPressed = false;
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: const Text(
            'لتجديد رخصة القيادة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ServiceContainer(
                        icon: Icons.person,
                        title: 'المعلومات الشخصية',
                        content: [Row()],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ServiceContainer(
                        icon: Icons.location_on,
                        title: 'بيانات العنوان',
                        content: [Row()],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ServiceContainer(
                        icon: Icons.file_upload,
                        title: ' الوثائق المطلوبة',
                        content: [
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomTextField(labelText: 'labelText'),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                10,
                                16,
                                16,
                                12,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: Checkbox(
                                          checkColor: MyColors.white,
                                          activeColor: MyColors.dodgerBlue,
                                          value: isChecked,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              isChecked = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 7),
                                  const Flexible(
                                    child: Text(
                                      'أُقر بأن جميع المعلومات المقدمة دقيقة وأوافق على معالجة بياناتي الشخصية لهذا الطلب.',

                                      style: TextStyle(
                                        color: MyColors.gray,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.start,
                                      //maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 90,
                      color: MyColors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(19, 15, 19, 15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                isButtonPressed = true;
                              });

                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  setState(() {
                                    isButtonPressed = false;
                                  });
                                },
                              );
                            },
                            icon: Icon(
                              Icons.send,
                              size: 20,
                              color:
                                  isButtonPressed
                                      ? MyColors.white
                                      : MyColors.grey,
                            ),
                            label: Text(
                              ' إرسال الطلب ',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color:
                                    isButtonPressed
                                        ? MyColors.white
                                        : MyColors.grey,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: MyColors.fadedGrey,
                              backgroundColor:
                                  isButtonPressed
                                      ? MyColors.dodgerBlue
                                      : MyColors.fadedGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
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
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  const CustomTextField({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 8, 19, 12),
      child: TextField(
        decoration: InputDecoration(
          fillColor: MyColors.white,
          labelText: labelText,
          labelStyle: TextStyle(color: MyColors.grey, fontSize: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // بدون إطار خارجي (اختياري)
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.blue), // لون عند التركيز
          ),
        ),
      ),
    );
  }
}
