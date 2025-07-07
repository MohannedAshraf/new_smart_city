// ignore_for_file: unused_import, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:citio/core/utils/mycolors.dart';
import 'package:citio/core/utils/project_strings.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:citio/core/widgets/service_container.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/screens/government_screen.dart';
import 'package:citio/screens/government_service_details.dart';
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

class Reapply extends StatefulWidget {
  final int id;
  final String title;
  final bool? isReApply;
  const Reapply({
    super.key,
    required this.id,
    required this.title,
    this.isReApply,
  });

  @override
  _Reapply createState() => _Reapply();
}

class _Reapply extends State<Reapply> {
  bool isLoading = true;
  bool isChecked = false;
  bool showError = false;
  bool isButtonPressed = false;
  bool showUploadError = false;

  List<RequiredFields> fields = [];
  List<RequiredFiles> files = [];
  List<RequiredFields> serviceData = [];

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
          serviceData.add(field);
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
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: MyColors.offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          media.height * 0.075,
        ), // تقريبًا 60 من 800
        child: AppBar(
          backgroundColor: MyColors.white,
          surfaceTintColor: MyColors.white,
          automaticallyImplyLeading: true,
          title: Text(
            AppStrings.apply(widget.title),
            style: TextStyle(
              fontSize: media.width * 0.05, // تقريبًا 20 من 400
              fontWeight: FontWeight.bold,
            ),
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
    final media = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: media.height * 0.01),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
                vertical: media.height * 0.008,
              ),
              child: ServiceContainer(
                icon: Icons.person,
                title: AppStrings.personalInfoTitle,
                content:
                    fields.map<Widget>((field) {
                      int index = serviceData.indexWhere(
                        (item) => item.id == field.id,
                      );

                      if (field.htmlType == 'text') {
                        return CustomTextField(
                          hintText: field.description,
                          header: field.fileName,
                          showError: fieldsError[index],
                          controller: controllers[field.fileName],
                          onChanged: (value) {
                            serviceData[index].fieldValueString = value;
                            serviceData[index].valueType = 'string';
                          },
                        );
                      } else if (field.htmlType == 'date') {
                        return DateTextField(
                          header: field.fileName,
                          showError: fieldsError[index],
                          controller: controllers[field.fileName],
                          onDateSelected: (value) {
                            serviceData[index].fieldValueDate = value;
                            serviceData[index].valueType = 'date';
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
                            serviceData[index].fieldValueInt = int.parse(value);
                            serviceData[index].valueType = 'int';
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
                            serviceData[index].fieldValueFloat = double.parse(
                              value,
                            );
                            serviceData[index].valueType = 'float';
                          },
                        );
                      } else {
                        return const SizedBox();
                      }
                    }).toList(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: media.width * 0.05,
                vertical: media.height * 0.008,
              ),
              child: ServiceContainer(
                icon: Icons.file_upload,
                title: AppStrings.requiredDocumentsTitle,
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
                            final pickedFile = result.files.first;

                            if (pickedFile.size > 5 * 1024 * 1024) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: MyColors.primary,
                                  content: Text(
                                    AppStrings.fileSizeExceeded,
                                    style: TextStyle(
                                      color: MyColors.white,
                                      fontSize: media.width * 0.035,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                              return;
                            }
                            setState(() {
                              uploadedFiles[file.id] = pickedFile;
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
            SizedBox(height: media.height * 0.015),
            Row(children: [applyButton()]),
          ],
        ),
      ),
    );
  }

  Expanded akcCheckBox() {
    final media = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(media.width * 0.05),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.05,
            media.height * 0.01,
            media.width * 0.05,
            media.height * 0.01,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(width: media.width * 0.02),
              Expanded(
                child: Stack(
                  children: [
                    Text(
                      AppStrings.confirmationStatement,
                      style: TextStyle(
                        color: MyColors.gray,
                        fontSize: media.width * 0.035,
                      ),
                    ),
                    if (showError)
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Text(
                          '*',
                          style: TextStyle(
                            color: MyColors.ambulance,
                            fontSize: media.width * 0.05,
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
    final media = MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        height: media.height * 0.1,
        color: MyColors.white,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.05,
            media.height * 0.015,
            media.width * 0.05,
            media.height * 0.015,
          ),
          child: SizedBox(
            width: double.infinity,
            height: media.height * 0.08,
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
                  setState(() => isButtonPressed = true);
                  await Future.delayed(const Duration(milliseconds: 200));
                  setState(() => isButtonPressed = false);
                  showPaymentSheet();
                }
              },
              icon: Icon(
                Icons.send,
                size: media.width * 0.05,
                color: isButtonPressed ? MyColors.white : MyColors.grey,
              ),
              label: Text(
                AppStrings.sendRequest,
                style: TextStyle(
                  fontSize: media.width * 0.045,
                  fontWeight: FontWeight.bold,
                  color: isButtonPressed ? MyColors.white : MyColors.grey,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: MyColors.fadedGrey,
                backgroundColor:
                    isButtonPressed ? MyColors.primary : MyColors.fadedGrey,
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

  bool validateFields() {
    bool isValid = true;
    for (int i = 0; i < fields.length; i++) {
      var value =
          serviceData[i].fieldValueString ??
          serviceData[i].fieldValueInt ??
          serviceData[i].fieldValueFloat ??
          serviceData[i].fieldValueDate;
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

  CardFieldInputDetails? card;

  void showPaymentSheet() {
    final media = MediaQuery.of(context).size;

    bool isPaymentLoading = false;
    final parentContext = context;
    showModalBottomSheet(
      backgroundColor: MyColors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setModalState) => DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.3,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return SafeArea(
                    child: Padding(
                      // duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: media.width * .04,
                        right: media.width * 0.04,
                        top: media.width * 0.04,
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              AppStrings.enterCardInfo,
                              style: TextStyle(
                                fontSize: media.width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: media.height * 0.02),
                            CardFormField(
                              onCardChanged: (cardDetails) {
                                setModalState(() {
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
                            SizedBox(height: media.height * 0.025),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (card == null ||
                                        !(card?.complete ?? false)) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            AppStrings.cardIncomplete,
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    setModalState(() {
                                      isPaymentLoading = true;
                                    });

                                    try {
                                      final paymentMethod = await Stripe
                                          .instance
                                          .createPaymentMethod(
                                            params:
                                                const PaymentMethodParams.card(
                                                  paymentMethodData:
                                                      PaymentMethodData(),
                                                ),
                                          );

                                      await ApplyGovernmentService().submit(
                                        serviceId: widget.id,
                                        serviceData: serviceData,
                                        files: uploadedFiles.values.toList(),
                                        paymentMethodID: paymentMethod.id,
                                      );

                                      if (!mounted) return;
                                      Navigator.pop(context);

                                      showDialog(
                                        context: parentContext,
                                        builder:
                                            (_) => AlertDialog(
                                              backgroundColor: MyColors.white,
                                              title: const Text(
                                                "Citio",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: MyColors.dodgerBlue,
                                                ),
                                              ),
                                              content: const Text(
                                                AppStrings.requestSent,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: MyColors.black,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    // Navigator.pop(context);
                                                    Navigator.of(
                                                      parentContext,
                                                    ).pop();
                                                    // Navigator.pushReplacement(
                                                    //   parentContext,
                                                    //   MaterialPageRoute(
                                                    //     builder:
                                                    //         (_) =>
                                                    //             GovernmentServiceDetails(
                                                    //               id: widget.id,
                                                    //             ),
                                                    //   ),
                                                    // );
                                                  },

                                                  child: const Text(
                                                    AppStrings.done,
                                                    style: TextStyle(
                                                      color:
                                                          MyColors.dodgerBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Navigator.pop(context);
                                                    Navigator.pushAndRemoveUntil(
                                                      parentContext,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (_) =>
                                                                const GovernmentScreen(),
                                                      ),
                                                      (route) => false,
                                                    );
                                                  },
                                                  child: const Text(
                                                    AppStrings.goToGov,
                                                    style: TextStyle(
                                                      color:
                                                          MyColors.dodgerBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      setModalState(() {
                                        isPaymentLoading = false;
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "${AppStrings.paymentFailure} : $e",
                                          ),
                                          backgroundColor: MyColors.primary,
                                          duration: const Duration(seconds: 10),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.primary,
                                    minimumSize: Size(
                                      media.width * 0.4,
                                      media.height * 0.06,
                                    ),
                                  ),
                                  child:
                                      isPaymentLoading
                                          ? const CircularProgressIndicator(
                                            color: MyColors.white,
                                          )
                                          : const Text(
                                            AppStrings.submitAndPay,
                                            style: TextStyle(
                                              color: MyColors.white,
                                            ),
                                          ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: MyColors.white,
                                    minimumSize: Size(
                                      media.width * 0.4,
                                      media.height * 0.06,
                                    ),
                                  ),
                                  child: const Text(
                                    AppStrings.cancel,
                                    style: TextStyle(color: MyColors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
      },
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
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            media.height * 0.01,
            media.width * 0.04,
            media.height * 0.005,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showError)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: media.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  header,
                  style: TextStyle(
                    fontSize: media.width * 0.035,
                    color: MyColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            0,
            media.width * 0.025,
            media.height * 0.015,
          ),
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
              contentPadding: EdgeInsets.fromLTRB(
                media.width * 0.03,
                media.height * 0.015,
                media.width * 0.03,
                media.height * 0.01,
              ),
              fillColor: MyColors.white,
              filled: true,
              hintText: hintText, // ممكن تستخدم: AppStrings.enterText
              hintStyle: TextStyle(
                color: MyColors.grey,
                fontSize: media.width * 0.04,
              ),
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
      ],
    );
  }
}

class DateTextField extends StatefulWidget {
  final String header;
  final bool showError;
  final TextEditingController? controller;
  final void Function(DateTime)? onDateSelected;

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

        widget.onDateSelected?.call(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            media.height * 0.01,
            media.width * 0.04,
            media.height * 0.005,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showError)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: media.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                widget.header,
                style: TextStyle(
                  fontSize: media.width * 0.035,
                  color: MyColors.black,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            media.height * 0.01,
            media.width * 0.025,
            media.height * 0.015,
          ),
          child: SizedBox(
            height: media.height * 0.06,
            child: TextField(
              controller: widget.controller,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: AppStrings.dateHint,
                hintStyle: TextStyle(
                  fontSize: media.width * 0.035,
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
    final media = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            media.height * 0.01,
            media.width * 0.04,
            media.height * 0.005,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showError)
                Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: media.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Expanded(
                child: Text(
                  widget.header,
                  style: TextStyle(
                    fontSize: media.width * 0.035,
                    color: MyColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            media.width * 0.025,
            media.height * 0.01,
            media.width * 0.025,
            media.height * 0.015,
          ),
          child: Stack(
            children: [
              DottedBorder(
                color: widget.showError ? MyColors.ambulance : MyColors.gray,
                strokeWidth: 1,
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                dashPattern: const [6, 4],
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    height: media.height * 0.16,
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
                          size: media.width * 0.08,
                        ),
                        SizedBox(height: media.height * 0.01),
                        Text(
                          widget.file != null
                              ? AppStrings.fileUploaded
                              : AppStrings.uploadFile,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.black,
                            fontSize: media.width * 0.035,
                          ),
                        ),
                        SizedBox(height: media.height * 0.005),
                        Text(
                          widget.file != null
                              ? widget.file!.name
                              : AppStrings.noFileSelected,
                          style: TextStyle(
                            fontSize: media.width * 0.03,
                            color: MyColors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
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
