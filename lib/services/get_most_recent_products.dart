import 'package:city/helper/api.dart';
import 'package:city/models/most_recent_products.dart';

class MostRecentProducts {
  Future<List<MostRecentProduct>> getMostRecentProduct() async {
    List<dynamic> data = await Api().get(
      url: 'https://service-provider.runasp.net/api/Products/most-recent',
    );
    List<MostRecentProduct> products = [];
    for (int i = 0; i < data.length; i++) {
      products.add(MostRecentProduct.fromJason(data[i]));
    }
    return products;
  }
}
