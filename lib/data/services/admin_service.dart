import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';

class AdminService {
  final Dio _dio = ApiClient.dio;

  Future<List<dynamic>> getRestaurants() async {
    final Response<dynamic> res = await _dio.get('/admin/restaurants');

    if (res.data is List) {
      return res.data as List<dynamic>;
    }
    return [];
  }

  Future<bool> deleteRestaurant(int id) async {
    final Response<dynamic> res = await _dio.delete('/admin/restaurants/$id');
    return _isSuccess(res);
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
  }) async {
    final Response<dynamic> res = await _dio.put(
      '/admin/restaurants/$id',
      data: {
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'rating': rating,
        'delivery_time': deliveryTime,
        'delivery_fee': deliveryFee,
        'min_order': minOrder,
        'distance': distance,
        'is_active': isActive ? 1 : 0,
      },
    );
    return _isSuccess(res);
  }

  bool _isSuccess(Response<dynamic> res) {
    return res.statusCode != null &&
        res.statusCode! >= 200 &&
        res.statusCode! < 300;
  }
}
