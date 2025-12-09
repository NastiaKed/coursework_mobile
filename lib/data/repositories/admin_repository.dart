import 'package:cours_work/data/services/admin_service.dart';

class AdminRepository {
  final AdminService _service = AdminService();

  Future<List<Map<String, dynamic>>> fetchRestaurants() async {
    final data = await _service.getRestaurants();
    return List<Map<String, dynamic>>.from(data);
  }

  Future<bool> deleteRestaurant(int id) {
    return _service.deleteRestaurant(id);
  }

  Future<bool> updateRestaurant({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    required double rating,
    required int deliveryTime,
    required double deliveryFee,
    required double minOrder,
    required double distance,
    required bool isActive,
  }) {
    return _service.updateRestaurant(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      rating: rating,
      deliveryTime: deliveryTime,
      deliveryFee: deliveryFee,
      minOrder: minOrder,
      distance: distance,
      isActive: isActive,
    );
  }
}