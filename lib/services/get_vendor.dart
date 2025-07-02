import 'package:citio/core/utils/variables.dart';
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
      url: '${Urls.serviceProviderbaseUrl}/api/Vendors/top-5-vendors',
      token: token,
    );
    List<Vendor> vendorList = [];
    for (int i = 0; i < data.length; i++) {
      vendorList.add(Vendor.fromJason(data[i]));
    }
    return vendorList;
  }

  Future<AllVendor> getAllVendors(int pageNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url:
          '${Urls.serviceProviderbaseUrl}/api/Vendors/for-mobile?pageNumer=$pageNumber&PageSize=10',
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
      url: '${Urls.serviceProviderbaseUrl}/api/Vendors/$id',
      token: token,
    );
    Vendor vendor = Vendor.fromJason(data);

    return vendor;
  }

  Future<AllVendor> searchVendors(String searchValue, int pageNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final encodedSearch = Uri.encodeComponent(searchValue);

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(
      url:
          '${Urls.serviceProviderbaseUrl}/api/Vendors/for-mobile?pageNumer=$pageNumber&SearchValue=$encodedSearch&PageSize=10',
      token: token,
    );
    AllVendor vendors = AllVendor.fromJason(data);

    return vendors;
  }

  Future<AllVendor> filterVendors(
    List<String> businessTypes,
    int pageNumber,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    final url = Uri.https(
      'service-provider.runasp.net',
      '/api/Vendors/for-mobile',
      {
        'pageNumer': pageNumber.toString(),
        'PageSize': ['3'],
        'BusinessTypes': businessTypes,
      },
    );

    // ignore: avoid_print
    print(url);
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(url: url.toString(), token: token);
    AllVendor vendors = AllVendor.fromJason(data);

    return vendors;
  }

  Future<AllVendor> searchFilterVendors(
    List<String> businessTypes,
    int pageNumber,
    String searchValue,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final encodedSearch = Uri.encodeComponent(searchValue);

    final url = Uri.https(
      'service-provider.runasp.net',
      '/api/Vendors/for-mobile',
      {
        'pageNumer': pageNumber.toString(),
        'SearchValue': encodedSearch,
        'PageSize': ['3'],
        'BusinessTypes': businessTypes,
      },
    );

    // ignore: avoid_print
    print(url);
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    dynamic data = await Api().get(url: url.toString(), token: token);
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
          '${Urls.serviceProviderbaseUrl}/api/SubCategory/$vendorId/SubCategories',
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
          '${Urls.serviceProviderbaseUrl}/api/SubCategory/$vendorId/$categoryId/Products',
      token: token,
    );
    List<VendorSubcategoryProducts> categoryProductsList = [];
    for (int i = 0; i < data.length; i++) {
      categoryProductsList.add(VendorSubcategoryProducts.fromJason(data[i]));
    }
    return categoryProductsList;
  }
}
