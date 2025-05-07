import 'dart:convert';

import 'package:citio/models/category_sub_category_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://service-provider.runasp.net/api";

  // الدالة لجلب قائمة الكاتيجوريز
  static Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/Categories'));

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // تحويل البيانات من JSON إلى قائمة من الكائنات
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      } else {
        // في حالة حدوث خطأ في الاستجابة من السيرفر
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      // التعامل مع الأخطاء مثل انقطاع الإنترنت أو أخطاء أخرى
      throw Exception('Error fetching categories: $e');
    }
  }

  // الدالة لجلب الساب كاتيجوريز بناءً على الـ categoryId
  static Future<List<SubCategoryModel>> fetchSubCategories(
    int categoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Categories/$categoryId/subCategories'),
      );

      // التحقق من حالة الاستجابة
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        // تحويل البيانات من JSON إلى قائمة من الكائنات
        return data.map((json) => SubCategoryModel.fromJson(json)).toList();
      } else {
        // في حالة حدوث خطأ في الاستجابة من السيرفر
        throw Exception('Failed to load subcategories: ${response.statusCode}');
      }
    } catch (e) {
      // التعامل مع الأخطاء مثل انقطاع الإنترنت أو أخطاء أخرى
      throw Exception('Error fetching subcategories: $e');
    }
  }

  // الدالة لجلب المنتجات الأكثر طلبًا
}
