class Dish {
  final int id;
  final String name;
  final String description;
  final double price;
  final double weight;
  final String imageUrl;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.weight,
    required this.imageUrl,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      price: _toDouble(json['price']),
      weight: _toDouble(json['weight']),
      imageUrl: (json['image_url'] ?? '') as String,
    );
  }
}

class Restaurant {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTime;
  final double deliveryFee;
  final double minOrder;
  final double distance;
  final List<Dish> dishes;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.distance,
    this.dishes = const [],
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      imageUrl: (json['image_url'] ?? '') as String,
      rating: _toDouble(json['rating']),
      deliveryTime: (json['delivery_time'] ?? 0) as int,
      deliveryFee: _toDouble(json['delivery_fee']),
      minOrder: _toDouble(json['min_order']),
      distance: _toDouble(json['distance']),
      dishes:
          (json['dishes'] as List<dynamic>?)
              ?.map((e) => Dish.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0.0;
}
