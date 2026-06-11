import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _role = 'farmer';

  void _signup() async {
    final success = await context.read<AuthProvider>().signup(
      username: _usernameController.text,
      password: _passwordController.text,
      role: _role,
      fullName: _fullNameController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ثبت نام با موفقیت انجام شد')),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در ثبت نام')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ثبت نام در محصول')),
      body: SingleChildScrollView(
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
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'نام کامل'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'farmer', child: Text('کشاورز')),
                DropdownMenuItem(value: 'buyer', child: Text('خریدار')),
                DropdownMenuItem(value: 'driver', child: Text('راننده کامیون')),
              ],
              onChanged: (val) => setState(() => _role = val!),
              decoration: const InputDecoration(labelText: 'نقش'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('ثبت نام'),
            ),
          ],
        ),
      ),
    );
  }
}
