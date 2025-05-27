import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Classe di utilità per effettuare richieste HTTP verso il backend.
/// Permette di inviare richieste GET, POST, PUT, DELETE specificando endpoint e azione.
/// Restituisce la risposta come mappa.
class WebUtilz {
  final String baseUrl = 'http://localhost/Progetto-Flutter/back/php/index.php';

  Future<Map<String, dynamic>> request({
    required String endpoint,
    required String action,
    String method = 'POST',
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final url = Uri.parse(baseUrl);
    try {
      late http.Response response;

      // Set default headers
      // to add a custom header, use the following format:
      // headers: {'X-Custom-Header': 'value'}
      final defaultHeaders = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-Endpoint': endpoint,
        'X-Action': action,
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
          if (kDebugMode) {
            print("----------------------------------------------------------");
            print(response.body);
            print("----------------------------------------------------------");
          }
          break;
        case 'UPDATE':
          response =
              await http.post(url, headers: defaultHeaders, body: encodedBody);
          if (kDebugMode) {
            print("----------------------------------------------------------");
            print(response.body);
            print("----------------------------------------------------------");
          }
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

      return json.decode(response.body);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      return {
        'success': false,
        'message': 'Errore di connessione (Lanciato WebUtilz R. 62): $e',
      };
    }
  }
}
