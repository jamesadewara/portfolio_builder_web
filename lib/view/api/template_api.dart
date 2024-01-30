import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:portfolio_builder_app/control/config.dart';
import 'package:portfolio_builder_app/view/api/api_prop.dart';

class TemplateApi {
  String baseUrl = api["template"]["base_url"];
  Map endpoints = api["template"]["endpoints"];

  Future<ApiRequest> getTemplates(String authToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/${endpoints["fetch"]}'),
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
