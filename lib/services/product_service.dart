import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:donut_app_3a_marketapp/models/product.dart';

class ProductService {
  static const String baseUrl = "http://localhost:8090/market-app/api";
  static Future<List<Product>> getAllProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/products"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Error al cargar productos");
    }
  }

  static Future<List<Product>> getProductsByCategory(int categoryId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/products/category/$categoryId"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception("Error al cargar productos por categoría");
    }
  }
}
