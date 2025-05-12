import 'dart:convert';
import 'package:http/http.dart' as http;

class WebUtilz {
  final String baseUrl = 'http://localhost/Progetto-TPS-Flutter/Progetto-Flutter/back/php/index.php';

  Future<Map<String, dynamic>> request({
    required String endpoint,
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse(baseUrl);
    try {
      late http.Response response;

      // Set default headers
      final defaultHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Endpoint': endpoint,
        ...?headers,
      };

      // Encode body for application/x-www-form-urlencoded
      final encodedBody = body?.map((k, v) => MapEntry(k, v.toString()));
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: defaultHeaders);
          break;
        case 'POST':
          response =
              await http.post(url, headers: defaultHeaders, body: encodedBody);
            print('POST: $encodedBody');
            print('Headers: $defaultHeaders');
            print('Response status: ${response.statusCode}');
            print('Response: ${response.body}');
          break;
        case 'PUT':
          response =
              await http.put(url, headers: defaultHeaders, body: encodedBody);
          break;
        case 'DELETE':
          response = await http.delete(url,
              headers: defaultHeaders, body: encodedBody);
          break;
        default:
          throw Exception('Metodo HTTP non supportato: $method');
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Errore ${response.statusCode}',
          'body': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Errore di connessione: $e',
      };
    }
  }
}
