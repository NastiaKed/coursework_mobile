import 'package:cours_work/data/services/api_client.dart';
import 'package:dio/dio.dart';

class ProfileService {
  final Dio _dio = ApiClient.dio;

  Future<Map<String, dynamic>> getProfile() async {
    final Response<Map<String, dynamic>> res =
    await _dio.get('/profile/main');
    return res.data ?? {};
  }

  Future<List<dynamic>> getOrderHistory() async {
    final Response<List<dynamic>> res =
    await _dio.get('/profile/orders');
    return res.data ?? [];
  }
}
