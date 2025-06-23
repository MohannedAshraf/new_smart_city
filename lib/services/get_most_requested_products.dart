import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';

import 'package:citio/models/most_requested_products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MostRequestedProducts {
  Future<List<MostRequestedProduct>> getMostRequestedProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    List<dynamic> data = await Api().get(
      url: '${Urls.serviceProviderbaseUrl}/api/Products/top5-most-requested',
      token: token,
    );
    List<MostRequestedProduct> products = [];
    for (int i = 0; i < data.length; i++) {
      products.add(MostRequestedProduct.fromJason(data[i]));
    }
    return products;
  }
}
