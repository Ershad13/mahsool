import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/truck.dart';

class TruckService {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Truck>> getAvailableTrucks({String? province, String? city}) async {
    String url = '$baseUrl/trucks';
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
      return data.map((json) => Truck.fromJson(json)).toList();
    }
    return [];
  }
}
