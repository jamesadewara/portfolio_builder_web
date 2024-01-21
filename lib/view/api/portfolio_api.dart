import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String baseUrl;

  ApiHelper(this.baseUrl);

  Future<Map<String, dynamic>> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return _handleResponse(response);
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
