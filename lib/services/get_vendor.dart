import 'package:city/helper/api.dart';
import 'package:city/models/all_vendors.dart';

import 'package:city/models/vendor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetVendor {
  Future<List<Vendor>> getVendor() async {
    List<dynamic> data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Vendors/top-5-vendors',
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
      url: 'https://service-provider.runasp.net/api/Vendors/for-mobile',
      token: token,
    );
    AllVendor vendors = AllVendor.fromJason(data);

    return vendors;
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
}
