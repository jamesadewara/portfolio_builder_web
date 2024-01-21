import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio_builder_app/control/config.dart';

class AuthApi {
  String baseUrl = api["auth"]["base_url"];
  Map endpoints = api["auth"]["endpoints"];

  Future logOut(String uid) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/${endpoints["logout"]}'),
        body: json.encode(uid),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
    } catch (e) {}
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      // Successful response
      return json.decode(response.body);
    } else {
      // Handle error cases
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }
}
