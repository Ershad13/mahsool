class Product {
  final int? id;
  final int farmerId;
  final String name;
  final String description;
  final double price;
  final String province;
  final String city;
  final double lat;
  final double lng;
  final double availableQuantity;

  Product({
    this.id,
    required this.farmerId,
    required this.name,
    required this.description,
    required this.price,
    required this.province,
    required this.city,
    required this.lat,
    required this.lng,
    required this.availableQuantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmer_id': farmerId,
      'name': name,
      'description': description,
      'price': price,
      'province': province,
      'city': city,
      'lat': lat,
      'lng': lng,
      'available_quantity': availableQuantity,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      farmerId: json['farmer_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      province: json['province'],
      city: json['city'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      availableQuantity: (json['available_quantity'] as num).toDouble(),
    );
  }
}
