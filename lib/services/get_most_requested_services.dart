import 'package:citio/core/utils/variables.dart';
import 'package:citio/helper/api.dart';
import 'package:citio/models/all_services_categories.dart';
import 'package:citio/models/gov_service_details.dart';
import 'package:citio/models/most_requested_services.dart';
import 'package:citio/models/available_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MostRequestedServices {
  Future<List<MostRequested>> getMostRequestedServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    // ignore: missing_required_param
    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Dashboard/MostRequestedServices',
      token: token,
    );
    List<MostRequested> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(MostRequested.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AvailableServices>> getAllServices() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Services/Available',
      token: token,
      // token: token
    );
    List<AvailableServices> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(AvailableServices.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AvailableServices>> filterServices(String category) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url:
          '${Urls.governmentbaseUrl}/api/Services/Available?serviceCategory=$category',
      token: token,
      // token: token
    );
    List<AvailableServices> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(AvailableServices.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AvailableServices>> searchServices(String keyWord) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url:
          '${Urls.governmentbaseUrl}/api/Services/Available?ServiceName=$keyWord',
      token: token,
      // token: token
    );
    List<AvailableServices> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(AvailableServices.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AvailableServices>> searchFilteredServices(
    String keyWord,
    String category,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url:
          '${Urls.governmentbaseUrl}/api/Services/Available?ServiceName=$keyWord&serviceCategory=$category',
      token: token,
      // token: token
    );
    List<AvailableServices> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(AvailableServices.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<AllServicesCategories>> getAllCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Services/Category',
      token: token,
    );
    List<AllServicesCategories> categories = [];
    for (int i = 0; i < data.length; i++) {
      categories.add(AllServicesCategories.fromJason(data[i]));
    }
    return categories;
  }

  Future<ServiceDetails> getServiceDetails(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    dynamic data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Services/$id/Details',
      token: token,
    );
    ServiceDetails service = ServiceDetails.fromJason(data);

    return service;
  }

  Future<List<RequiredFields>> getRequiredFields(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Fields/Required/Service/$id',
      token: token,
      // token: token
    );
    List<RequiredFields> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(RequiredFields.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<RequiredFields>> getAttachedFields(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Fields/Attached/Request/$id',
      token: token,
      // token: token
    );
    List<RequiredFields> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(RequiredFields.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<RequiredFiles>> getRequiredFiles(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Files/Required/Service/$id',
      token: token,
      // token: token
    );
    List<RequiredFiles> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(RequiredFiles.fromJason(data[i]));
    }
    return requestsList;
  }

  Future<List<RequiredFiles>> getAttachedFiles(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('لم يتم العثور على التوكن!');
    }

    // ignore: missing_required_param
    List<dynamic> data = await Api().get(
      url: '${Urls.governmentbaseUrl}/api/Files/Attached/Request/$id',
      token: token,
      // token: token
    );
    List<RequiredFiles> requestsList = [];
    for (int i = 0; i < data.length; i++) {
      requestsList.add(RequiredFiles.fromJason(data[i]));
    }
    return requestsList;
  }
}
