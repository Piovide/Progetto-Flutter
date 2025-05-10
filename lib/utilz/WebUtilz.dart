import 'dart:convert';
import 'package:http/http.dart' as http;
class WebUtilz {
  static const String baseUrl = 'http://localhost/progetto_flutter/back/php/index.php';

  static Future<http.Response> getRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'X-Endpoint': endpoint,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  static Future<http.Response> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Endpoint': endpoint,
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  static Future<http.Response> putRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final uri = Uri.parse(baseUrl);
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Endpoint': endpoint,
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  static Future<http.Response> deleteRequest(String endpoint,
      {Map<String, String>? queryParams}) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.delete(uri, headers: {
        'Content-Type': 'application/json',
        'X-Endpoint': endpoint,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }
}
