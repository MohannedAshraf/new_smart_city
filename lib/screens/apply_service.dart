// ignore_for_file: unused_import, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:citio/core/utils/variables.dart' show MyColors;
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/services/apply_government_service.dart';
import 'package:citio/services/get_most_requested_services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
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
  bool isLoading = true;
  bool isChecked = false;
  bool showError = false;
  bool isButtonPressed = false;
  bool showUploadError = false;

  List<RequiredFields> fields = [];
  List<RequiredFiles> files = [];
  List<Map<String, dynamic>> serviceData = [];

  Map<String, TextEditingController> controllers = {};
  Map<int, PlatformFile> uploadedFiles = {};

  List<bool> fieldsError = [];
  Map<int, bool> filesError = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final fetchedFields = await MostRequestedServices().getRequiredFields(
        widget.id,
      );
      final fetchedFiles = await MostRequestedServices().getRequiredFiles(
        widget.id,
      );

      for (var field in fetchedFields) {
        if (!controllers.containsKey(field.fileName)) {
          controllers[field.fileName] = TextEditingController();
          fieldsError.add(false);
          serviceData.add({
            'FieldId': field.id,
            'FieldValueString': null,
            'FieldValueInt': null,
            'FieldValueFloat': null,
            'FieldValueDate': null,
          });
        }
      }
      for (var file in fetchedFiles) {
        filesError[file.id] = false;
      }
      setState(() {
        fields = fetchedFields;
        files = fetchedFiles;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

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
            'لطلب ${widget.title}',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : buildForm(),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          showError: fieldsError[index],
                          controller: controllers[field.fileName],
                          onChanged: (value) {
                            serviceData[index]['FieldValueString'] = value;
                          },
                        );
                      } else if (field.htmlType == 'date') {
                        return DateTextField(
                          header: field.fileName,
                          showError: fieldsError[index],
                          controller: controllers[field.fileName],
                          onDateSelected: (value) {
                            serviceData[index]['FieldValueDate'] = value;
                          },
                        );
                      } else if (field.htmlType == 'number') {
                        return CustomTextField(
                          hintText: field.description,
                          header: field.fileName,
                          showError: fieldsError[index],
                          isInt: true,
                          controller: controllers[field.fileName],
                          onChanged: (value) {
                            serviceData[index]['FieldValueInt'] = value;
                          },
                        );
                      } else if (field.htmlType == 'float') {
                        return CustomTextField(
                          hintText: field.description,
                          header: field.fileName,
                          showError: fieldsError[index],
                          isFloat: true,
                          controller: controllers[field.fileName],
                          onChanged: (value) {
                            serviceData[index]['FieldValueFloat'] = value;
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: ServiceContainer(
                icon: Icons.file_upload,
                title: 'الوثائق المطلوبة',
                content:
                    files.map<Widget>((file) {
                      return CustomUploadBox(
                        file: uploadedFiles[file.id],
                        header: file.fileName,
                        showError: filesError[file.id] ?? false,
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();

                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              uploadedFiles[file.id] = result.files.first;
                            });
                          }
                        },
                        onRemove: () {
                          setState(() {
                            uploadedFiles.remove(file.id);
                          });
                        },
                      );
                    }).toList(),
              ),
            ),
            Row(children: [akcCheckBox()]),
            SizedBox(height: 13.h),
            Row(children: [applyButton()]),
          ],
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

  Widget applyButton() {
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
              onPressed: () async {
                bool fieldsValid = validateFields();
                bool filesValid = validateFiles();

                if (!isChecked) {
                  setState(() {
                    showError = true;
                  });
                }

                if (fieldsValid && filesValid && isChecked) {
                  setState(() {
                    isButtonPressed = true;
                  });

                  if (fieldsValid && filesValid && isChecked) {
                    setState(() => isButtonPressed = true);

                    await Future.delayed(const Duration(milliseconds: 200));
                    setState(() => isButtonPressed = false);

                    showPaymentSheet();
                  }
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

  bool validateFields() {
    bool isValid = true;
    for (int i = 0; i < fields.length; i++) {
      var value =
          serviceData[i]['FieldValueString'] ??
          serviceData[i]['FieldValueInt'] ??
          serviceData[i]['FieldValueFloat'] ??
          serviceData[i]['FieldValueDate'];
      if (value == null || value.toString().isEmpty) {
        fieldsError[i] = true;
        isValid = false;
      } else {
        fieldsError[i] = false;
      }
    }
    setState(() {});
    return isValid;
  }

  bool validateFiles() {
    bool isValid = true;
    // filesError = List.generate(files.length, (_) => false);

    for (int i = 0; i < files.length; i++) {
      if (!uploadedFiles.containsKey(files[i].id)) {
        filesError[files[i].id] = true;
        isValid = false;
      }
    }
    setState(() {});
    return isValid;
  }

  // Future<void> handlePaymentAndSubmit() async {
  //   try {
  //     final paymentMethod = await Stripe.instance.createPaymentMethod(
  //       params: const PaymentMethodParams.card(
  //         paymentMethodData: PaymentMethodData(
  //           billingDetails: BillingDetails(), // optional
  //         ),
  //       ),
  //     );

  //     final paymentMethodId = paymentMethod.id;

  //     ApplyGovernmentService().submit(
  //       serviceId: widget.id,
  //       serviceData: serviceData,
  //       files: uploadedFiles.values.toList(),
  //       paymentMethodID: paymentMethodId,
  //     );
  //   } catch (e) {
  //     print('حدث خطأ أثناء الدفع: $e');
  //     // يمكنك عرض رسالة للمستخدم
  //   }
  // }

  CardFieldInputDetails? card;

  void showPaymentSheet() {
    showModalBottomSheet(
      backgroundColor: MyColors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'أدخل بيانات البطاقة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CardFormField(
                  onCardChanged: (cardDetails) {
                    setState(() {
                      card = cardDetails;
                    });
                  },
                  style: CardFormStyle(
                    backgroundColor: MyColors.white,
                    borderColor: Colors.grey,
                    textColor: Colors.black,
                    borderRadius: 8,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print('تم ضغط');

                    if (card == null || !(card?.complete ?? false)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("يرجى إكمال بيانات البطاقة"),
                        ),
                      );
                      return;
                    }
                    try {
                      final paymentMethod = await Stripe.instance
                          .createPaymentMethod(
                            params: const PaymentMethodParams.card(
                              paymentMethodData: PaymentMethodData(),
                            ),
                          );

                      Navigator.pop(context);

                      ApplyGovernmentService().submit(
                        serviceId: widget.id,
                        serviceData: serviceData,
                        files: uploadedFiles.values.toList(),
                        paymentMethodID: paymentMethod.id,
                      );
                      print(paymentMethod.id);
                    } catch (e) {
                      print("Stripe error: $e");
                    }
                  },
                  child: const Text('إرسال ودفع'),
                ),
              ],
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
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.top,
            onChanged: onChanged,
            minLines: minLines,
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
  final VoidCallback? onRemove;

  const CustomUploadBox({
    super.key,
    required this.header,
    this.showError = false,
    this.file,
    this.onTap,
    this.onRemove,
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
          child: Stack(
            children: [
              DottedBorder(
                color: widget.showError ? MyColors.ambulance : MyColors.gray,
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
                              widget.file != null
                                  ? MyColors.grey
                                  : MyColors.black,
                          size: 36.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.file != null
                              ? 'تم تحميل ملف'
                              : 'اضغط لرفع ملف',
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
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.file != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      widget.onRemove?.call();
                    },
                    child: const Icon(
                      Icons.close_outlined,
                      color: MyColors.ambulance,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
