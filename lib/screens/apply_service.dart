// ignore_for_file: library_private_types_in_public_api, annotate_overrides, unused_field, avoid_print

import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RequiredFields>>(
      future: MostRequestedServices().getRequiredFields(widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final fields = snapshot.data!;

        return Scaffold(
          backgroundColor: MyColors.offWhite,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: AppBar(
              backgroundColor: MyColors.white,
              surfaceTintColor: MyColors.white,
              automaticallyImplyLeading: true,
              title: Text(
                'لتجديد رخصة القيادة',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    child: const ServiceContainer(
                      icon: Icons.location_on,
                      title: 'بيانات العنوان',
                      content: [SizedBox()],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    child: ServiceContainer(
                      icon: Icons.file_upload,
                      title: 'الوثائق المطلوبة',
                      content: [
                        const CustomTextField(
                          hintText: 'labelText',
                          header: 'header',
                        ),
                        const CustomTextField(
                          hintText: 'labelText',
                          header: 'header',
                        ),
                        const CustomTextField(
                          hintText: 'labelText',
                          header: 'header',
                          showError: true,
                          isInt: true,
                        ),
                        const DateTextField(header: 'header', showError: true),
                        const SizedBox(
                          height: 120,
                          child: CustomTextField(
                            header: 'header',
                            hintText: 'scrollable وطويلة شوية للعنوان',
                            maxLines: 5,
                            expands: true,
                          ),
                        ),
                        const CustomDropDown(
                          showError: true,
                          header: 'header',
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
                  SizedBox(height: 13.h),
                  Row(children: [applyButton()]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded akcCheckBox() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 5.h),
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
              SizedBox(width: 7.w),
              Expanded(
                child: Stack(
                  children: [
                    Text(
                      'أُقر بأن جميع المعلومات المقدمة دقيقة وأوافق على معالجة بياناتي الشخصية لهذا الطلب.',
                      style: TextStyle(color: MyColors.gray, fontSize: 14.sp),
                    ),
                    if (showError)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: MyColors.ambulance,
                            fontSize: 20.sp,
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
        height: 90.h,
        color: MyColors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(19.w, 15.h, 19.w, 15.h),
          child: SizedBox(
            width: double.infinity,
            height: 70.h,
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
              },
              icon: Icon(
                Icons.send,
                size: 20.sp,
                color: isButtonPressed ? MyColors.white : MyColors.grey,
              ),
              label: Text(
                ' إرسال الطلب ',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: isButtonPressed ? MyColors.white : MyColors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: MyColors.fadedGrey,
                backgroundColor:
                    isButtonPressed ? MyColors.dodgerBlue : MyColors.fadedGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
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
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 15.w, 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showError)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  header,
                  style: TextStyle(fontSize: 14.sp, color: MyColors.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 12.h),
          child: SizedBox(
            height: 45.h,
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
                contentPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
                fillColor: MyColors.white,
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(color: MyColors.grey, fontSize: 16.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: showError ? Colors.red : MyColors.gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
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
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 15.w, 4.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showError)
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    widget.header,
                    style: TextStyle(fontSize: 14.sp, color: MyColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
          child: SizedBox(
            height: 45.h,
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
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
                  borderSide: BorderSide(
                    color: widget.showError ? Colors.red : MyColors.gray,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r),
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
              padding: EdgeInsets.fromLTRB(10.w, 8.h, 15.w, 0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showError)
                    Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    widget.header,
                    style: TextStyle(fontSize: 14.sp, color: MyColors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
          child: DropdownButtonFormField<String>(
            menuMaxHeight: 250.h,
            borderRadius: BorderRadius.circular(15.r),
            focusColor: MyColors.fadedGrey,

            iconEnabledColor: MyColors.white,
            isExpanded: true,
            dropdownColor: MyColors.white,
            value: widget.selectedValue,
            // onChanged: widget.onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: MyColors.black, fontSize: 12.sp),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              fillColor: MyColors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(
                  color: widget.showError ? Colors.red : MyColors.gray,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.r),
                borderSide: BorderSide(
                  color: widget.showError ? Colors.red : MyColors.dodgerBlue,
                ),
              ),
            ),
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
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 15.w, 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showError)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  header,
                  style: TextStyle(fontSize: 14.sp, color: MyColors.black),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 12.h),
          child: DottedBorder(
            color: MyColors.gray,
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: Radius.circular(15.r),
            dashPattern: const [6, 4],
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 120.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: MyColors.grey,
                      size: 36.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subTitle,
                      style: TextStyle(fontSize: 12.sp, color: MyColors.grey),
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
