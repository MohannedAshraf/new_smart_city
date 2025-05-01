import 'package:city/helper/api.dart';

import 'package:city/models/most_requested_products.dart';

class MostRequestedProducts {
  Future<List<MostRequestedProduct>> getMostRequestedProduct() async {
    List<dynamic> data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Products/most-requested',
    );
    List<MostRequestedProduct> products = [];
    for (int i = 0; i < data.length; i++) {
      products.add(MostRequestedProduct.fromJason(data[i]));
    }
    return products;
  }
}
