import 'dart:convert';
import 'package:donut_app_3a_marketapp/models/product.dart';
import 'package:donut_app_3a_marketapp/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String baseUrl = "http://localhost:8090/market-app/api";

  // Método para obtener los encabezados, incluyendo el token de autenticación
  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Método para obtener todos los productos
  static Future<List<Product>> getAllProducts() async {
    try {
      final headers = await _getHeaders();
      print("Headers: $headers"); // Imprime los encabezados para depurar

      final response = await http.get(
        Uri.parse(
            "$baseUrl/products/all"), // URL para obtener todos los productos
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(
            "Error al cargar productos. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar productos: $e"); // Captura y muestra el error
      rethrow;
    }
  }

  // Método para obtener productos por categoría
  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final headers = await _getHeaders();
      print("Headers enviados: $headers");
      print("Categoría solicitada: $categoryId");

      final response = await http.get(
        Uri.parse("$baseUrl/products/category/$categoryId"),
        headers: headers,
      );

      print("Código de respuesta: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception(
            "Error al cargar productos por categoría. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error al cargar productos por categoría: $e");
      rethrow;
    }
  }
}
