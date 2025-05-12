import 'package:citio/helper/api.dart';
import 'package:citio/models/all_vendors.dart';

import 'package:citio/models/vendor.dart';
import 'package:citio/models/vendor_subcategory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetVendor {
  Future<List<Vendor>> getVendor() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Vendors/top-5-vendors',
      token: token,
    );
    List<Vendor> vendorList = [];
    for (int i = 0; i < data.length; i++) {
      vendorList.add(Vendor.fromJason(data[i]));
    }
    return vendorList;
  }

  Future<AllVendor> getAllVendors() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url:
          'https://service-provider.runasp.net/api/Vendors/for-mobile?PageSize=50',
      token: token,
    );
    AllVendor vendors = AllVendor.fromJason(data);

    return vendors;
  }

  Future<Vendor> getVendorById(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Vendors/$id',
      token: token,
    );
    Vendor vendor = Vendor.fromJason(data);

    return vendor;
  }

  Future<AllVendor> searchVendors(String searchValue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url:
          'https://service-provider.runasp.net/api/Vendors/for-mobile?searchVlaue=$searchValue',
      token: token,
    );
    AllVendor vendors = AllVendor.fromJason(data);

    return vendors;
  }

  Future<List<VendorSubcategory>> getVendorSubcategory(String vendorId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url:
          'https://service-provider.runasp.net/api/SubCategory/$vendorId/SubCategories',
      token: token,
    );
    List<VendorSubcategory> categoryList = [];
    for (int i = 0; i < data.length; i++) {
      categoryList.add(VendorSubcategory.fromJason(data[i]));
    }
    return categoryList;
  }

  Future<List<VendorSubcategoryProducts>> getVendorSubcategoryProducts(
    String vendorId,
    int categoryId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url:
          'https://service-provider.runasp.net/api/SubCategory/$vendorId/$categoryId/Products',
      token: token,
    );
    List<VendorSubcategoryProducts> categoryProductsList = [];
    for (int i = 0; i < data.length; i++) {
      categoryProductsList.add(VendorSubcategoryProducts.fromJason(data[i]));
    }
    return categoryProductsList;
  }
}
