import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/truck.dart';

class TruckService {
  static const String baseUrl = 'http://localhost:8080';

  Future<List<Truck>> getAvailableTrucks() async {
    final response = await http.get(Uri.parse('$baseUrl/trucks'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Truck.fromJson(json)).toList();
    }
    return [];
  }
}
