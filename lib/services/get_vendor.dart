import 'package:city/helper/api.dart';

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
}
