import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _qtyController = TextEditingController();

  LatLng? _selectedLocation;
  String _province = '';
  String _city = '';

  final ProductService _productService = ProductService();

  void _onMapTap(LatLng location) async {
    setState(() {
      _selectedLocation = location;
    });
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _province = placemarks.first.administrativeArea ?? '';
          _city = placemarks.first.locality ?? '';
        });
      }
    } catch (e) {
      print('Error geocoding: $e');
    }
  }

  void _submit() async {
    if (_selectedLocation == null) return;

    final user = context.read<AuthProvider>().user!;
    final product = Product(
      farmerId: user.id,
      name: _nameController.text,
      description: _descController.text,
      price: double.parse(_priceController.text),
      province: _province,
      city: _city,
      lat: _selectedLocation!.latitude,
      lng: _selectedLocation!.longitude,
      availableQuantity: double.parse(_qtyController.text),
    );

    final success = await _productService.addProduct(product);
    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('افزودن محصول جدید')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'نام محصول')),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'توضیحات')),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'قیمت'), keyboardType: TextInputType.number),
            TextField(controller: _qtyController, decoration: const InputDecoration(labelText: 'مقدار موجود'), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            Text('استان: $_province، شهر: $_city'),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(target: LatLng(35.6892, 51.3890), zoom: 10),
                onTap: _onMapTap,
                markers: _selectedLocation == null ? {} : {
                  Marker(markerId: const MarkerId('selected'), position: _selectedLocation!)
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text('ثبت محصول')),
          ],
        ),
      ),
    );
  }
}
