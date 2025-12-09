import 'package:cours_work/data/models/cart.dart';
import 'package:cours_work/data/services/cart_service.dart';
import 'package:flutter/material.dart';

class CartRepository {
  final CartService _service = CartService();

  Future<Object> addDishToCart({
    required int userId,
    required int dishId,
    int quantity = 1,
  }) async {
    return await _handleRequest<Object>(
      () => _service.addToCart(
        userId: userId,
        dishId: dishId,
        quantity: quantity,
      ),
      defaultValue: false,
      label: 'addDishToCart',
    );
  }

  Future<List<CartItem>> fetchCart(int userId) async {
    return await _handleRequest<List<CartItem>>(
      () => _service.getCart(userId),
      defaultValue: const [],
      label: 'fetchCart',
    );
  }

  Future<bool> clearCart(int userId) async {
    return await _handleRequest<bool>(
      () => _service.clearCart(userId),
      defaultValue: false,
      label: 'clearCart',
    );
  }

  Future<bool> checkout(int userId) async {
    return await _handleRequest<bool>(
      () => _service.checkout(userId),
      defaultValue: false,
      label: 'checkout',
    );
  }

  Future<T> _handleRequest<T>(
    Future<T> Function() call, {
    required T defaultValue,
    required String label,
  }) async {
    try {
      return await call();
    } catch (e) {
      debugPrint('❌ $label error: $e');
      return defaultValue;
    }
  }
}
