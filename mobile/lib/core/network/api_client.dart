import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  // Configuración automática de URL según el entorno de ejecución:
  // - Android Emulator: 10.0.2.2 apunta a localhost de tu PC (puerto 8001 mapeado por Docker)
  // - Web / Desktop: localhost
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8001';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8001';
    } else {
      return 'http://localhost:8001';
    }
  } 

  // Método genérico para hacer POST
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data; // Éxito
      } else {
        throw Exception(data['detail'] ?? 'Error en el servidor');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
