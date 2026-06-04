import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../config.dart';

class ProductService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<bool> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      body: jsonEncode(product.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  Future<List<Product>> getProducts({String? province, String? city}) async {
    String url = '$baseUrl/products';
    if (province != null || city != null) {
      url += '?';
      if (province != null) url += 'province=$province';
      if (city != null) {
        if (province != null) url += '&';
        url += 'city=$city';
      }
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    }
    return [];
  }
}
