import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../config.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final _truckTypeController = TextEditingController();
  final _capacityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _cityController = TextEditingController();

  void _registerTruck() async {
    final user = context.read<AuthProvider>().user!;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/trucks'),
      body: jsonEncode({
        'driver_id': user.id,
        'truck_type': _truckTypeController.text,
        'capacity': double.parse(_capacityController.text),
        'province': _provinceController.text,
        'city': _cityController.text,
        'lat': 0.0,
        'lng': 0.0,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کامیون با موفقیت ثبت شد')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پنل راننده')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('ثبت مشخصات کامیون', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _truckTypeController, decoration: const InputDecoration(labelText: 'نوع کامیون')),
            TextField(controller: _capacityController, decoration: const InputDecoration(labelText: 'ظرفیت (تن)'), keyboardType: TextInputType.number),
            TextField(controller: _provinceController, decoration: const InputDecoration(labelText: 'استان فعالیت')),
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'شهر فعالیت')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _registerTruck, child: const Text('ثبت کامیون')),
          ],
        ),
      ),
    );
  }
}
