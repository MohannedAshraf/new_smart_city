// ignore_for_file: missing_required_param

import 'package:citio/helper/api.dart';
import 'package:citio/models/most_recent_products.dart';

class MostRecentProducts {
  Future<List<MostRecentProduct>> getMostRecentProduct() async {
    List<dynamic> data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Banners/top-Banners',
    );
    List<MostRecentProduct> products = [];
    for (int i = 0; i < data.length; i++) {
      products.add(MostRecentProduct.fromJason(data[i]));
    }
    return products;
  }
}
