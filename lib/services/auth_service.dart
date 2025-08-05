import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://localhost:8090/market-app/api";

  // Función para realizar login y obtener el token
  static Future<String?> login(String correo, String contrasena) async {
    final url = Uri.parse("$baseUrl/auth/login");
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "correo": correo,
      "contrasena": contrasena,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      // Guardamos el token en SharedPreferences
      await _saveToken(token);

      return token;
    } else if (response.statusCode == 401) {
      print("Credenciales inválidas");
      return null;
    } else {
      print("Error en el servidor: ${response.statusCode}");
      throw Exception("Error en el servidor: ${response.statusCode}");
    }
  }

  // Función para guardar el token en SharedPreferences
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Función para obtener el token de SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Función para eliminar el token
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
