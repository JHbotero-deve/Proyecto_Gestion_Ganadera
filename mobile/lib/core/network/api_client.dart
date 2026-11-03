import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // ⚠️ IMPORTANTE: Esta URL debe ser la de tu backend.
  // Si el backend corre en tu PC, usa esta. Si está en un servidor, cámbiala.
  static const String baseUrl = 'http://localhost:8000'; 

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