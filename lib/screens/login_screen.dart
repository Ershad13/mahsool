import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'farmer_dashboard.dart';
import 'buyer_dashboard.dart';
import 'driver_dashboard.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    final success = await context.read<AuthProvider>().login(
      _usernameController.text,
      _passwordController.text,
    );

    if (success) {
      final user = context.read<AuthProvider>().user!;
      Widget nextScreen;
      switch (user.role) {
        case 'farmer':
          nextScreen = const FarmerDashboard();
          break;
        case 'buyer':
          nextScreen = const BuyerDashboard();
          break;
        case 'driver':
          nextScreen = const DriverDashboard();
          break;
        case 'admin':
        case 'employee':
          nextScreen = const AdminDashboard();
          break;
        default:
          nextScreen = const LoginScreen();
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ورود ناموفق بود')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ورود به محصول')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'نام کاربری'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'رمز عبور'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('ورود'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: const Text('ثبت نام نکرده‌اید؟ ثبت نام کنید'),
            ),
          ],
        ),
      ),
    );
  }
}
