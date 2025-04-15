import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/pref_service.dart';

import '../helpers/locator.dart';

class HttpService {
  PrefService get _prefService => locator<PrefService>();
  GlobalService get _globalService => locator<GlobalService>();

  final headers = {
    "Content-Type": "application/json",
    "WLID": "94DE1528-DE42-498A-A07E-4A458E97240E"
  };

  HttpService();

  Future<dynamic> getData(String endpoint) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .get(Uri.parse('${await _globalService.getHost()}/$endpoint'),
            headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .post(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> postListData(
      String endpoint, List<Map<String, dynamic>>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .post(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic>? data) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });

    final response = await http
        .put(
          Uri.parse('${await _globalService.getHost()}/$endpoint'),
          body: json.encode(data),
          headers: headers,
        )
        .timeout(const Duration(minutes: 1));

    return response;
  }

  Future<dynamic> deleteData(String endpoint) async {
    headers.addAll({
      "Authorization": "Bearer ${await _prefService.getString(PrefKey.token)}"
    });
    final response = await http
        .delete(Uri.parse('${await _globalService.getHost()}/$endpoint'),
            headers: headers)
        .timeout(const Duration(minutes: 1));

    return response;
  }


}
