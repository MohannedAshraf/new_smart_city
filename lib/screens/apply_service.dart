// ignore_for_file: library_private_types_in_public_api, annotate_overrides, unused_field, avoid_print

import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/services/apply_government_service.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:dotted_border/dotted_border.dart';

class ApplyService extends StatefulWidget {
  final int id;
  final String title;
  const ApplyService({super.key, required this.id, required this.title});

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
  List<Map<String, dynamic>> serviceData = [];
  Map<String, TextEditingController> controllers = {};
  TextEditingController birthDateController = TextEditingController();
  Map<int, PlatformFile> uploadedFiles = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: Text(
            widget.title,
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
              FutureBuilder<List<RequiredFields>>(
                future: MostRequestedServices().getRequiredFields(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('لا توجد بيانات مطلوبة.'));
                  }

                  final fields = snapshot.data!;
                  fields.forEach((field) {
                    controllers.putIfAbsent(
                      field.fileName,
                      () => TextEditingController(),
                    );

                    serviceData.add({
                      'FieldId': field.id,
                      'FieldValueString': '',
                    });
                  });
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: ServiceContainer(
                      icon: Icons.person,
                      title: 'المعلومات الشخصية',
                      content:
                          fields.map<Widget>((field) {
                            int index = serviceData.indexWhere(
                              (item) => item['FieldId'] == field.id,
                            );
                            if (field.htmlType == 'text') {
                              return CustomTextField(
                                hintText: field.description,
                                header: field.fileName,
                                controller: controllers[field.fileName],
                                onChanged: (value) {
                                  serviceData[index]['FieldValueString'] =
                                      value;
                                },
                              );
                            } else if (field.htmlType == 'date') {
                              return DateTextField(
                                header: field.fileName,
                                controller: controllers[field.fileName],
                                onDateSelected: (value) {
                                  serviceData[index]['FieldValueString'] =
                                      value;
                                },
                              );
                            } else if (field.htmlType == 'number') {
                              return CustomTextField(
                                hintText: field.description,
                                header: field.fileName,
                                isInt: true,
                                controller: controllers[field.fileName],
                                onChanged: (value) {
                                  serviceData[index]['FieldValueString'] =
                                      value;
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          }).toList(),
                    ),
                  );
                },
              ),
              FutureBuilder<List<RequiredFiles>>(
                future: MostRequestedServices().getRequiredFiles(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('لا يوجد وثائق مطلوبة.'));
                  }

                  final files = snapshot.data!;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    child: ServiceContainer(
                      icon: Icons.file_upload,
                      title: 'الوثائق المطلوبة',

                      content:
                          files.map<Widget>((file) {
                            return CustomUploadBox(
                              file: uploadedFiles[file.id],
                              //title: 'اضغط للتحميل',
                              //subTitle: file.fileExtension,
                              header: file.fileName,
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null && result.files.isNotEmpty) {
                                  setState(() {
                                    uploadedFiles[file.id] = result.files.first;
                                  });
                                }
                              },
                            );
                          }).toList(),
                    ),
                  );
                },
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
                      //title: 'Tap to upload ID document',
                      //subTitle: 'PDF, JPG, PNG (Max 5MB)',
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
                    });
                  }
                  ///// hena elpayemnt ba3den lama te3mleh
                  ///
                  print(serviceData);
                  print(uploadedFiles);
                  ApplyGovernmentService().submit(
                    serviceId: widget.id,
                    serviceData: serviceData,
                    files: uploadedFiles.values.toList(),
                  );
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
  final TextEditingController? controller;

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
    this.controller,
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
              controller: controller,
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
  final TextEditingController? controller;
  final void Function(String)? onDateSelected;

  const DateTextField({
    super.key,
    required this.header,
    this.controller,
    this.showError = false,
    this.onDateSelected,
  });

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
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
        String formattedDate = DateFormat('MM/dd/yy').format(picked);
        widget.controller!.text = formattedDate;

        if (widget.onDateSelected != null) {
          widget.onDateSelected!(formattedDate);
        }
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
              controller: widget.controller,
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

class CustomUploadBox extends StatefulWidget {
  final String header;
  final bool showError;
  final PlatformFile? file;
  final VoidCallback? onTap;

  const CustomUploadBox({
    super.key,
    required this.header,
    this.showError = false,
    this.file,
    this.onTap,
  });

  @override
  State<CustomUploadBox> createState() => _CustomUploadBoxState();
}

class _CustomUploadBoxState extends State<CustomUploadBox> {
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
              if (widget.showError)
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
                  widget.header,
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
              onTap: widget.onTap,
              child: Container(
                height: 120.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.file != null
                          ? Icons.picture_as_pdf
                          : Icons.cloud_upload_outlined,
                      color:
                          widget.file != null ? MyColors.grey : MyColors.black,
                      size: 36.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.file != null ? 'اضغط لرفع الملف' : 'تم تحميل ملف',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MyColors.black,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.file != null
                          ? widget.file!.name
                          : 'لم يتم اختيار ملف',
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
