import 'database.dart';

void main() {
  final dbHelper = DatabaseHelper();
  final tables = dbHelper.db.select("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");

  final tableNames = tables.map((row) => row['name'] as String).toList();
  print('Tables: $tableNames');

  final expectedTables = ['users', 'products', 'trucks', 'reservations'];
  for (final table in expectedTables) {
    if (!tableNames.contains(table)) {
      print('Missing table: $table');
      return;
    }
  }
  print('All tables created successfully.');
  dbHelper.close();
}
