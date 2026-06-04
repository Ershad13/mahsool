import 'package:flutter/material.dart';

import 'add_product_screen.dart';

class FarmerDashboard extends StatelessWidget {
  const FarmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پنل کشاورز')),
      body: const Center(child: Text('خوش آمدید کشاورز عزیز')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
