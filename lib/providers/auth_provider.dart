import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  final AuthService _authService = AuthService();

  User? get user => _user;

  Future<bool> login(String username, String password) async {
    final user = await _authService.login(username, password);
    if (user != null) {
      _user = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signup({
    required String username,
    required String password,
    required String role,
    required String fullName,
    String? province,
    String? city,
  }) async {
    return await _authService.signup(
      username: username,
      password: password,
      role: role,
      fullName: fullName,
      province: province,
      city: city,
    );
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
