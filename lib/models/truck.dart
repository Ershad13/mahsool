class Truck {
  final int id;
  final int driverId;
  final String truckType;
  final double capacity;
  final String province;
  final String city;
  final double lat;
  final double lng;
  final bool isAvailable;

  Truck({
    required this.id,
    required this.driverId,
    required this.truckType,
    required this.capacity,
    required this.province,
    required this.city,
    required this.lat,
    required this.lng,
    required this.isAvailable,
  });

  factory Truck.fromJson(Map<String, dynamic> json) {
    return Truck(
      id: json['id'],
      driverId: json['driver_id'],
      truckType: json['truck_type'],
      capacity: (json['capacity'] as num).toDouble(),
      province: json['province'] ?? '',
      city: json['city'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['is_available'] == 1,
    );
  }
}
