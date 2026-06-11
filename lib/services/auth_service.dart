import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> signup({
    required String username,
    required String password,
    required String role,
    required String fullName,
    String? province,
    String? city,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      body: jsonEncode({
        'username': username,
        'password': password,
        'role': role,
        'full_name': fullName,
        'province': province,
        'city': city,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    return response.statusCode == 200;
  }
}
