import 'dart:convert';
import 'package:http/http.dart' as http;

class WebUtilz {
  static const String baseUrl = 'https://localhost/back/php/api';

  static Future<http.Response> getRequest(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
      final response = await http.get(uri);
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  static Future<http.Response> postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  static Future<http.Response> putRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  static Future<http.Response> deleteRequest(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint').replace(queryParameters: queryParams);
      final response = await http.delete(uri);
      return response;
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }
}