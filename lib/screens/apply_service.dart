// ignore_for_file: library_private_types_in_public_api, annotate_overrides, unused_field, avoid_print

import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class ApplyService extends StatefulWidget {
  final int id;
  const ApplyService({super.key, required this.id});

  @override
  _ApplyService createState() => _ApplyService();
}

class _ApplyService extends State<ApplyService> {
  FilePickerResult? result;
  bool isChecked = false;
  bool showError = false;
  bool isButtonPressed = false;
  bool isFileUploaded = false;
  bool showUploadError = false;

  late Future<List<RequiredFields>> _fields;
  late Future<List<RequiredFiles>> _files;

  late Future<List<dynamic>> _combinedFuture;

  @override
  void initState() {
    super.initState();
    _combinedFuture = Future.wait([
      MostRequestedServices().getRequiredFields(widget.id),
      MostRequestedServices().getRequiredFiles(widget.id),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _combinedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final fields = snapshot.data![0] as List<RequiredFields>;
          final files = snapshot.data![1] as List<RequiredFiles>;

          // final fields = snapshot.data!;

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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: ServiceContainer(
                        icon: Icons.person,
                        title: 'المعلومات الشخصية',
                        content:
                            fields.map<Widget>((field) {
                              if (field.htmlType == 'text') {
                                return CustomTextField(
                                  hintText: field.description,
                                  header: field.fileName,
                                );
                              } else if (field.htmlType == 'date') {
                                return DateTextField(header: field.fileName);
                              } else if (field.htmlType == 'number') {
                                return CustomTextField(
                                  hintText: field.description,
                                  header: field.fileName,
                                  isInt: true,
                                );
                              } else {
                                return const SizedBox();
                              }
                            }).toList(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: ServiceContainer(
                        icon: Icons.file_upload,
                        title: 'الوثائق المطلوبة',
                        content:
                            files.map<Widget>((file) {
                              return CustomUploadBox(
                                header: file.fileName,
                                title: 'اضغط للتحميل',
                                subTitle: file.fileExtension,
                              );
                            }).toList(),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: ServiceContainer(
                        icon: Icons.file_upload,
                        title: 'الوثائق المطلوبة',
                        content: [
                          CustomUploadBox(
                            header: 'header',
                            title: 'Tap to upload ID document',
                            subTitle: 'PDF, JPG, PNG (Max 5MB)',
                            showError: showUploadError,
                            onTap: () async {
                              result = await FilePicker.platform.pickFiles(
                                allowMultiple: true,
                              );
                              if (result == null) {
                                print("No file selected");
                              } else {
                                print("تم تحميل");
                                setState(() {
                                  isFileUploaded = true;
                                });
                                for (var element in result!.files) {
                                  print(element.name);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    Row(children: [akcCheckBox()]),
                    const SizedBox(height: 13),
                    Row(children: [applyButton()]),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: const Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Expanded akcCheckBox() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Row(
            children: [
              Checkbox(
                checkColor: MyColors.white,
                activeColor: MyColors.dodgerBlue,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                    if (isChecked) showError = false;
                  });
                },
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Stack(
                  children: [
                    const Text(
                      'أُقر بأن جميع المعلومات المقدمة دقيقة وأوافق على معالجة بياناتي الشخصية لهذا الطلب.',
                      style: TextStyle(color: MyColors.gray, fontSize: 14),
                    ),
                    if (showError)
                      const Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: MyColors.ambulance,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded applyButton() {
    return Expanded(
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
                if (!isChecked) {
                  setState(() {
                    showError = true;
                  });
                } else {
                  setState(() {
                    isButtonPressed = true;
                  });

                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      isButtonPressed = false;
                    });
                  });
                  if (!isFileUploaded) {
                    setState(() {
                      showUploadError = true;
                    });
                  } else {
                    setState(() {
                      showUploadError = false;
                      // تابع تنفيذ الإرسال هنا
                    });
                  }
                  ///// hena elpayemnt ba3den lama te3mleh
                }
                // setState(() {
                //   isButtonPressed = true;
                // });

                // Future.delayed(const Duration(milliseconds: 200), () {
                //   setState(() {
                //     isButtonPressed = false;
                //   });
                // });
              },
              icon: Icon(
                Icons.send,
                size: 20,
                color: isButtonPressed ? MyColors.white : MyColors.grey,
              ),
              label: Text(
                ' إرسال الطلب ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: isButtonPressed ? MyColors.white : MyColors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: MyColors.fadedGrey,
                backgroundColor:
                    isButtonPressed ? MyColors.dodgerBlue : MyColors.fadedGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
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
  final String header;
  final bool showError;
  final bool isInt;
  final int? fixedLength;
  final bool isFloat;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.minLines = 1,
    this.maxLines = 5,
    this.expands = false,
    required this.header,
    this.showError = false,
    this.isInt = false,
    this.isFloat = false,
    this.fixedLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 15, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showError)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  header,
                  style: const TextStyle(fontSize: 14, color: MyColors.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
          child: SizedBox(
            height: 45,
            child: TextField(
              textAlignVertical: TextAlignVertical.top,
              onChanged: onChanged,
              minLines: expands ? null : minLines,
              maxLines: expands ? null : maxLines,
              expands: expands,
              keyboardType:
                  isInt
                      ? TextInputType.number
                      : isFloat
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
              inputFormatters: [
                if (isInt) FilteringTextInputFormatter.digitsOnly,
                if (isFloat)
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                if (fixedLength != null)
                  LengthLimitingTextInputFormatter(fixedLength!),
              ],
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
                  borderSide: BorderSide(
                    color: showError ? Colors.red : MyColors.gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: showError ? Colors.red : MyColors.dodgerBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DateTextField extends StatefulWidget {
  final String header;
  final bool showError;
  const DateTextField({
    super.key,
    required this.header,
    this.showError = false,
  });

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

      locale: const Locale('en', 'US'),
    );
    if (picked != null) {
      setState(() {
        _controller.text = DateFormat('MM/dd/yy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 15, 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showError)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    widget.header,
                    style: const TextStyle(fontSize: 14, color: MyColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
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
                  borderSide: BorderSide(
                    color: widget.showError ? Colors.red : MyColors.gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: widget.showError ? Colors.red : MyColors.dodgerBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final String hintText;
  final List<String> items;
  final String? selectedValue;
  final void Function(String?)? onChanged;
  final String header;
  final bool showError;

  const CustomDropDown({
    super.key,
    required this.hintText,
    required this.items,
    this.selectedValue,
    this.onChanged,
    required this.header,
    this.showError = false,
  });
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 15, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showError)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    widget.header,
                    style: const TextStyle(fontSize: 14, color: MyColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
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
                borderSide: BorderSide(
                  color: widget.showError ? Colors.red : MyColors.gray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: widget.showError ? Colors.red : MyColors.dodgerBlue,
                ),
              ),
            ),
            // icon: const Icon(Icons.keyboard_arrow_down),
            items:
                widget.items.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    enabled: true,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedValue = value;
              });
              widget.onChanged; //الفانكشن التانية يا لولوووو
            },
          ),
        ),
      ],
    );
  }
}

class CustomUploadBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback? onTap;
  final bool showError;
  final String header;

  const CustomUploadBox({
    super.key,
    required this.title,
    required this.subTitle,
    required this.header,
    this.showError = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 15, 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showError)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  header,
                  style: const TextStyle(fontSize: 14, color: MyColors.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
          child: DottedBorder(
            color: MyColors.gray,
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(15),
            dashPattern: const [6, 4],
            child: GestureDetector(
              onTap: onTap,
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: MyColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
