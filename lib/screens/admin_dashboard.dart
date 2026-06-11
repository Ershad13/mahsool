import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> _reservations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAllReservations();
  }

  void _loadAllReservations() async {
    // In a real app, we would have a special admin endpoint to see all
    // For now we just show a message or try to fetch some data
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پنل مدیریت / کارمندان')),
      body: _loading
        ? const Center(child: CircularProgressIndicator())
        : const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 100, color: Colors.green),
                SizedBox(height: 20),
                Text('مدیر عزیز خوش آمدید', style: TextStyle(fontSize: 20)),
                Text('در این بخش می‌توانید تمامی تراکنش‌ها را مشاهده کنید'),
              ],
            ),
          ),
    );
  }
}
