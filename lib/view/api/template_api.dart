import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio_builder_app/control/config.dart';
import 'package:portfolio_builder_app/view/api/api_prop.dart';

class TemplateApi {
  String baseUrl = api["auth"]["base_url"];
  Map endpoints = api["auth"]["endpoints"];

  Future<ApiRequest> signup(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/${endpoints["signup"]}'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<ApiRequest> signin(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/${endpoints["signin"]}'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<ApiRequest> updateUser(
      String authToken, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${endpoints["update"]}'),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return _handleResponse(response);
  }

  Future<ApiRequest> deleteUser(String authToken) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/${endpoints["delete"]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return _handleResponse(response);
  }

  Future<ApiRequest> getUser(String authToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/${endpoints["detail"]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return _handleResponse(response);
  }

  Future<ApiRequest> signout(String authToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/${endpoints["logout"]}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return _handleResponse(response);
  }

  ApiRequest _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Successful response
      return ApiRequest(error: false, data: json.encode(response.body));
    } else if (response.statusCode == 400) {
      // Handle Bad Request
      return ApiRequest(
          error: true, data: '${ApiMsg.badRequest} ${response.body}');
    } else if (response.statusCode == 401) {
      // Handle Unauthorized
      return ApiRequest(error: true, data: ApiMsg.unAuthorized);
    } else if (response.statusCode == 403) {
      // Handle Forbidden
      return ApiRequest(error: true, data: ApiMsg.forbidden);
    } else if (response.statusCode == 404) {
      // Handle Not Found
      return ApiRequest(error: true, data: ApiMsg.notFound);
    } else if (response.statusCode == 500) {
      // Handle Internal Server Error
      return ApiRequest(error: true, data: ApiMsg.internalServerError);
    } else {
      // Handle other status codes
      return ApiRequest(
          error: true,
          data: '${ApiMsg.externalServerError} ${response.statusCode}');
    }
  }
}
