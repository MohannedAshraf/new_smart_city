// ignore_for_file: unused_field, use_build_context_synchronously
import 'package:citio/helper/api_register.dart';
import 'package:citio/screens/mylogin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  OutlineInputBorder myBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
    );
  }

  Future<void> registerUser() async {
    setState(() => _isLoading = true);

    try {
      final response = await ApiRegisterHelper.registerUser(
        fullName: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        address: addressController.text.trim(),
        buildingNumber: buildingController.text.trim(),
        floorNumber: floorController.text.trim(),
      );

      setState(() => _isLoading = false);

      if (response.isSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyloginPage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("فشل في إنشاء الحساب")));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0.w,
                  vertical: 10.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset("assets/icon/citio.svg", height: 100.h),
                    Text(
                      "إنشاء حساب",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "انضم إلى Citio لإدارة خدمات مدينتك",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 18.h),

                    // Full Name
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "الاسم الكامل",
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator:
                          (value) => value!.isEmpty ? "يرجى إدخال الاسم" : null,
                    ),
                    SizedBox(height: 15.h),

                    // Phone
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "رقم الهاتف",
                        prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? "يرجى إدخال رقم الهاتف" : null,
                    ),
                    SizedBox(height: 15.h),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "البريد الإلكتروني",
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? "يرجى إدخال البريد الإلكتروني"
                                  : null,
                    ),
                    SizedBox(height: 15.h),

                    // Password
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "كلمة المرور",
                        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (value.length < 6) {
                          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15.h),

                    // Address
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        hintText: "العنوان",
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        border: myBorder(),
                        enabledBorder: myBorder(),
                        focusedBorder: myBorder(),
                      ),
                      validator:
                          (value) =>
                              value!.isEmpty ? "يرجى إدخال العنوان" : null,
                    ),
                    SizedBox(height: 15.h),

                    // Building + Floor
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: buildingController,
                            decoration: InputDecoration(
                              hintText: "رقم المبنى",
                              prefixIcon: const Icon(
                                Icons.apartment,
                                color: Colors.grey,
                              ),
                              border: myBorder(),
                              enabledBorder: myBorder(),
                              focusedBorder: myBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: TextFormField(
                            controller: floorController,
                            decoration: InputDecoration(
                              hintText: "الدور",
                              prefixIcon: const Icon(
                                Icons.stairs,
                                color: Colors.grey,
                              ),
                              border: myBorder(),
                              enabledBorder: myBorder(),
                              focusedBorder: myBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        },
                        child: Text(
                          _isLoading ? "جاري التسجيل..." : "أنشئ الحساب",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Already have account?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("هل لديك حساب؟"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyloginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "تسجيل الدخول",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
