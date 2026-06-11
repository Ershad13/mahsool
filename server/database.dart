import 'package:sqlite3/sqlite3.dart';

class DatabaseHelper {
  late final Database db;

  DatabaseHelper() {
    db = sqlite3.open('mahsool.db');
    _createTables();
  }

  void _createTables() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL, -- farmer, buyer, driver, employee, admin
        full_name TEXT,
        province TEXT,
        city TEXT
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        farmer_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        province TEXT NOT NULL,
        city TEXT NOT NULL,
        lat REAL,
        lng REAL,
        available_quantity REAL NOT NULL,
        FOREIGN KEY (farmer_id) REFERENCES users (id)
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS trucks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        driver_id INTEGER NOT NULL,
        truck_type TEXT,
        capacity REAL,
        province TEXT,
        city TEXT,
        lat REAL,
        lng REAL,
        is_available INTEGER DEFAULT 1,
        FOREIGN KEY (driver_id) REFERENCES users (id)
      )
    ''');

    db.execute('''
      CREATE TABLE IF NOT EXISTS reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        buyer_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        truck_id INTEGER,
        quantity REAL NOT NULL,
        status TEXT DEFAULT 'pending', -- pending, confirmed, completed, cancelled
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (buyer_id) REFERENCES users (id),
        FOREIGN KEY (product_id) REFERENCES products (id),
        FOREIGN KEY (truck_id) REFERENCES trucks (id)
      )
    ''');
  }

  void close() {
    db.dispose();
  }
}
