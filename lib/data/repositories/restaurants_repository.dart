import 'package:cours_work/data/models/restaurant.dart';
import 'package:cours_work/data/services/restaurants_service.dart';
import 'package:flutter/material.dart';

class RestaurantsRepository {
  final RestaurantsService _service = RestaurantsService();

  Future<List<Restaurant>> fetchRestaurants() async {
    return await _handle(
      _service.getAllRestaurants,
      fallback: const [],
      label: 'fetchRestaurants',
    );
  }

  Future<List<Restaurant>> fetchSorted(String sortBy) async {
    return await _handle(
      () => _service.getSortedRestaurants(sortBy),
      fallback: const [],
      label: 'fetchSorted',
    );
  }

  Future<String?> saveFiltered({
    required List<int> categoryIds,
    required List<int> textFilterIds,
  }) async {
    try {
      final response = await _service.saveFiltered(
        categoryIds: categoryIds,
        textFilterIds: textFilterIds,
      );

      final searchId = response['search_id'];
      if (searchId == null) {
        debugPrint('⚠️ saveFiltered не повернув search_id');
        return null;
      }

      return searchId.toString();
    } catch (e) {
      debugPrint('❌ saveFiltered error: $e');
      return null;
    }
  }

  Future<List<Restaurant>> fetchSavedFiltered({
    required String searchId,
  }) async {
    return await _handle(
      () => _service.getSavedFiltered(searchId: searchId),
      fallback: const [],
      label: 'fetchSavedFiltered',
    );
  }

  Future<Restaurant?> fetchRestaurantById(int id) async {
    try {
      final data = await _service.getRestaurantById(id);
      return Restaurant.fromJson(data);
    } catch (e) {
      debugPrint('❌ fetchRestaurantById error: $e');
      return null;
    }
  }

  Future<T> _handle<T>(
    Future<T> Function() call, {
    required T fallback,
    required String label,
  }) async {
    try {
      return await call();
    } catch (e) {
      debugPrint('❌ $label error: $e');
      return fallback;
    }
  }
}
