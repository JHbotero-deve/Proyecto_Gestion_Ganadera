import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // Configuración automática de URL según el entorno de ejecución:
  // - Android Emulator: 10.0.2.2 apunta a localhost de tu PC (puerto 8001 mapeado por Docker)
  // - Web / Desktop: localhost:8001
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8001';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8001';
    } else {
      return 'http://localhost:8001';
    }
  }

  // Método genérico para hacer POST
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data as Map<String, dynamic>;
      } else {
        throw Exception(data['detail'] ?? 'Error en el servidor');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Método genérico para hacer GET
  static Future<dynamic> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Error en el servidor');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
