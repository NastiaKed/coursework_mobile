import 'package:cours_work/data/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final ProfileService _service = ProfileService();

  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await _service.getProfile();
    } catch (e) {
      debugPrint('❌ getProfile error: $e');
      return {};
    }
  }

  Future<List<dynamic>> getOrderHistory() async {
    try {
      return await _service.getOrderHistory();
    } catch (e) {
      debugPrint('❌ getOrderHistory error: $e');
      return [];
    }
  }
}
