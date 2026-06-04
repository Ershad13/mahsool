import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:crypto/crypto.dart';

import 'database.dart';

class ApiServer {
  final DatabaseHelper dbHelper = DatabaseHelper();

  Router get router {
    final router = Router();

    // Auth
    router.post('/signup', _signupHandler);
    router.post('/login', _loginHandler);

    // Products
    router.post('/products', _addProductHandler);
    router.get('/products', _getProductsHandler);

    // Trucks
    router.post('/trucks', _registerTruckHandler);
    router.get('/trucks', _getTrucksHandler);

    // Reservations
    router.post('/reservations', _createReservationHandler);
    router.get('/reservations/user/<userId>', _getReservationsHandler);

    return router;
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<Response> _signupHandler(Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final username = payload['username'];
    final password = _hashPassword(payload['password']);
    final role = payload['role'];
    final fullName = payload['full_name'];
    final province = payload['province'];
    final city = payload['city'];

    try {
      dbHelper.db.execute(
        'INSERT INTO users (username, password, role, full_name, province, city) VALUES (?, ?, ?, ?, ?, ?)',
        [username, password, role, fullName, province, city],
      );
      return Response.ok(jsonEncode({'message': 'User created successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _loginHandler(Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final username = payload['username'];
    final password = _hashPassword(payload['password']);

    final results = dbHelper.db.select(
      'SELECT id, username, role, full_name FROM users WHERE username = ? AND password = ?',
      [username, password],
    );

    if (results.isEmpty) {
      return Response.forbidden(jsonEncode({'error': 'Invalid credentials'}));
    }

    final user = results.first;
    return Response.ok(jsonEncode({
      'id': user['id'],
      'username': user['username'],
      'role': user['role'],
      'full_name': user['full_name'],
    }));
  }

  Future<Response> _addProductHandler(Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final farmerId = payload['farmer_id'];
    final name = payload['name'];
    final description = payload['description'];
    final price = payload['price'];
    final province = payload['province'];
    final city = payload['city'];
    final lat = payload['lat'];
    final lng = payload['lng'];
    final quantity = payload['available_quantity'];

    try {
      dbHelper.db.execute(
        'INSERT INTO products (farmer_id, name, description, price, province, city, lat, lng, available_quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [farmerId, name, description, price, province, city, lat, lng, quantity],
      );
      return Response.ok(jsonEncode({'message': 'Product added successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getProductsHandler(Request request) async {
    final province = request.url.queryParameters['province'];
    final city = request.url.queryParameters['city'];

    String query = 'SELECT * FROM products';
    List<dynamic> params = [];

    if (province != null || city != null) {
      query += ' WHERE';
      if (province != null) {
        query += ' province = ?';
        params.add(province);
      }
      if (city != null) {
        if (province != null) query += ' AND';
        query += ' city = ?';
        params.add(city);
      }
    }

    final results = dbHelper.db.select(query, params);
    return Response.ok(jsonEncode(results.map((r) => Map<String, dynamic>.from(r)).toList()));
  }

  Future<Response> _registerTruckHandler(Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final driverId = payload['driver_id'];
    final truckType = payload['truck_type'];
    final capacity = payload['capacity'];
    final province = payload['province'];
    final city = payload['city'];
    final lat = payload['lat'];
    final lng = payload['lng'];

    try {
      dbHelper.db.execute(
        'INSERT INTO trucks (driver_id, truck_type, capacity, province, city, lat, lng) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [driverId, truckType, capacity, province, city, lat, lng],
      );
      return Response.ok(jsonEncode({'message': 'Truck registered successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getTrucksHandler(Request request) async {
    final results = dbHelper.db.select('SELECT * FROM trucks WHERE is_available = 1');
    return Response.ok(jsonEncode(results.map((r) => Map<String, dynamic>.from(r)).toList()));
  }

  Future<Response> _createReservationHandler(Request request) async {
    final payload = jsonDecode(await request.readAsString());
    final buyerId = payload['buyer_id'];
    final productId = payload['product_id'];
    final truckId = payload['truck_id'];
    final quantity = payload['quantity'];

    try {
      dbHelper.db.execute(
        'INSERT INTO reservations (buyer_id, product_id, truck_id, quantity) VALUES (?, ?, ?, ?)',
        [buyerId, productId, truckId, quantity],
      );
      return Response.ok(jsonEncode({'message': 'Reservation created successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getReservationsHandler(Request request, String userId) async {
    final results = dbHelper.db.select('SELECT * FROM reservations WHERE buyer_id = ?', [userId]);
    return Response.ok(jsonEncode(results.map((r) => Map<String, dynamic>.from(r)).toList()));
  }
}

void main() async {
  final api = ApiServer();
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware((innerHandler) {
        return (request) async {
          final response = await innerHandler(request);
          return response.change(headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type',
            'Content-Type': 'application/json',
          });
        };
      })
      .addHandler(api.router.call);

  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server listening on port ${server.port}');
}
