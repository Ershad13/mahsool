import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/truck.dart';
import '../providers/auth_provider.dart';
import '../services/truck_service.dart';
import '../config.dart';

class ReservationScreen extends StatefulWidget {
  final Product product;
  const ReservationScreen({super.key, required this.product});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final TruckService _truckService = TruckService();
  List<Truck> _trucks = [];
  Truck? _selectedTruck;
  final _qtyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrucks();
  }

  void _loadTrucks() async {
    final trucks = await _truckService.getAvailableTrucks();
    setState(() {
      _trucks = trucks;
    });
  }

  void _reserve() async {
    final user = context.read<AuthProvider>().user!;
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/reservations'),
      body: jsonEncode({
        'buyer_id': user.id,
        'product_id': widget.product.id,
        'truck_id': _selectedTruck?.id,
        'quantity': double.parse(_qtyController.text),
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رزرو با موفقیت انجام شد')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('رزرو ${widget.product.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _qtyController, decoration: const InputDecoration(labelText: 'مقدار رزرو'), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            const Text('انتخاب راننده کامیون:'),
            Expanded(
              child: ListView.builder(
                itemCount: _trucks.length,
                itemBuilder: (context, index) {
                  final truck = _trucks[index];
                  return RadioListTile<Truck>(
                    title: Text('${truck.truck_type} - ظرفیت: ${truck.capacity}'),
                    subtitle: Text('استان: ${truck.province}، شهر: ${truck.city}'),
                    value: truck,
                    groupValue: _selectedTruck,
                    onChanged: (val) => setState(() => _selectedTruck = val),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _reserve, child: const Text('تایید رزرو')),
          ],
        ),
      ),
    );
  }
}
