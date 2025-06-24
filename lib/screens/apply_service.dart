// ignore_for_file: library_private_types_in_public_api, annotate_overrides

import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class ApplyService extends StatefulWidget {
  const ApplyService({super.key});
  @override
  _ApplyService createState() => _ApplyService();
}

class _ApplyService extends State<ApplyService> {
  FilePickerResult? result;

  bool isChecked = false;
  bool isButtonPressed = false;
  Widget build(BuildContext context) {
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
              const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: ServiceContainer(
                        icon: Icons.person,
                        title: 'المعلومات الشخصية',
                        content: [Row()],
                      ),
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
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
                          const CustomTextField(hintText: 'labelText'),
                          const CustomTextField(hintText: 'labelText'),
                          const CustomTextField(hintText: 'labelText'),
                          const DateTextField(),
                          Container(
                            height: 120,
                            child: CustomTextField(
                              hintText: 'scrollable وطويلة شوية للعنوان',
                              maxLines: 5,
                              expands: true,
                            ),
                          ),
                          CustomDropDown(
                            hintText: r'اختر منطقتك/حيك',
                            items: [
                              'الحي الأول',
                              'الحي التالت',
                              'حي الزهور',
                              'الحي الجديد',
                              'الحي الأجدد منه',
                              'حي مساكن السلام',
                              'الحي الأخير',
                            ],
                          ),

                          CustomUploadBox(
                            title: 'Tap to upload ID document',
                            subTitle: 'PDF, JPG, PNG (Max 5MB)',
                            onTap: () async {
                              result = await FilePicker.platform.pickFiles(
                                allowMultiple: true,
                              );
                              if (result == null) {
                                print("No file selected");
                              } else {
                                print("تم تحميل");
                                setState(() {});
                                for (var element in result!.files) {
                                  print(element.name);
                                }
                              }
                            },
                          ),
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
  final String hintText;
  final void Function(String)? onChanged;
  final int minLines;
  final int maxLines;
  final bool expands;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.minLines = 1,
    this.maxLines = 5,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: SizedBox(
        height: 45,

        child: TextField(
          textAlignVertical: TextAlignVertical.top,
          onChanged: onChanged,
          minLines: expands ? null : minLines,
          maxLines: expands ? null : maxLines,
          expands: expands,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            fillColor: MyColors.white,
            filled: true,
            hintText: hintText,

            hintStyle: const TextStyle(color: MyColors.grey, fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: MyColors.gray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: MyColors.dodgerBlue),
            ),
          ),
        ),
      ),
    );
  }
}

class DateTextField extends StatefulWidget {
  const DateTextField({super.key});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColors.dodgerBlue,
              onPrimary: MyColors.white,
              onSurface: MyColors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: MyColors.dodgerBlue),
            ),
          ),
          child: child!,
        );
      },

      locale: const Locale('en', 'US'), // لو عايزة التاريخ إنجليزي
    );
    if (picked != null) {
      setState(() {
        _controller.text = DateFormat('MM/dd/yy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: SizedBox(
        height: 45,
        child: TextField(
          controller: _controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: 'mm/dd/yy',
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: MyColors.gray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: MyColors.dodgerBlue),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?)? onChanged;

  const CustomDropDown({
    super.key,
    required this.hintText,
    required this.items,
    this.selectedValue,
    this.onChanged,
  });
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: DropdownButtonFormField<String>(
        menuMaxHeight: 250,
        borderRadius: BorderRadius.circular(15),
        focusColor: MyColors.fadedGrey,

        iconEnabledColor: MyColors.white,
        isExpanded: true,
        dropdownColor: MyColors.white,
        value: widget.selectedValue,
        // onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: MyColors.black, fontSize: 12),
          suffixIcon: const Icon(Icons.arrow_drop_down),
          fillColor: MyColors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: MyColors.gray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: MyColors.dodgerBlue),
          ),
        ),
        // icon: const Icon(Icons.keyboard_arrow_down),
        items:
            widget.items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item),
                enabled: true,
              );
            }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedValue = value;
          });
          widget.onChanged; //الفانكشن التانية يا لولوووو
        },
      ),
    );
  }
}

class CustomUploadBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onTap;

  const CustomUploadBox({
    super.key,
    required this.title,
    required this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
      child: DottedBorder(
        color: MyColors.gray, // غيريه حسب الثيم
        strokeWidth: 1,
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        dashPattern: [6, 4],
        child: GestureDetector(
          onTap: onTap,

          // borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 120,
            width: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  color: MyColors.grey,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: const TextStyle(fontSize: 12, color: MyColors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
