import 'dart:convert';

import 'package:cours_work/data/repositories/cart_repository.dart';
import 'package:cours_work/data/repositories/profile_repository.dart';
import 'package:cours_work/data/services/local_storage.dart';
import 'package:cours_work/navigation/app_routes.dart';
import 'package:cours_work/presentation/cart/state/cart_counter.dart';
import 'package:flutter/material.dart';

class ProfileOrdersPage extends StatefulWidget {
  const ProfileOrdersPage({super.key});

  @override
  State<ProfileOrdersPage> createState() => _ProfileOrdersPageState();
}

class _ProfileOrdersPageState extends State<ProfileOrdersPage> {
  final ProfileRepository _repo = ProfileRepository();
  final CartRepository _cartRepo = CartRepository();

  bool loading = true;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final data = await _repo.getOrderHistory();
    setState(() {
      orders = List<Map<String, dynamic>>.from(data);
      loading = false;
    });
  }

  List<Map<String, dynamic>> safeParseItems(dynamic raw) {
    if (raw == null) return [];

    if (raw is List) {
      return raw.map<Map<String, dynamic>>((e) {
        if (e is Map) return Map<String, dynamic>.from(e);
        return {};
      }).toList();
    }

    if (raw is String) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map<Map<String, dynamic>>((e) {
            if (e is Map) return Map<String, dynamic>.from(e);
            return {};
          }).toList();
        }
      } catch (_) {}
    }

    return [];
  }

  Future<void> repeatOrder(List<Map<String, dynamic>> items) async {
    final userId = await LocalStorage.getUserId();
    if (userId == null) return;

    for (final item in items) {
      final dishId = int.parse(item['dish_id'].toString());
      final qty = int.tryParse(item['quantity'].toString()) ?? 1;

      await _cartRepo.addDishToCart(
        userId: userId,
        dishId: dishId,
        quantity: qty,
      );

      cartCounter.increment();
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Страви додано до кошика!')));

    Navigator.pushNamed(context, AppRoutes.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Історія замовлень',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : orders.isEmpty
          ? const Center(
              child: Text(
                'Замовлень поки немає',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final order = orders[i];
                final items = safeParseItems(order['items']);

                return _OrderCard(
                  order: order,
                  items: items,
                  onRepeat: () => repeatOrder(items),
                );
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final List<Map<String, dynamic>> items;
  final VoidCallback onRepeat;

  const _OrderCard({
    required this.order,
    required this.items,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Замовлення #${order['id']}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Сума: ${order['total']}₴",
            style: const TextStyle(color: Colors.black54, fontSize: 15),
          ),

          const SizedBox(height: 14),

          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                "• ${item['dish_name']} — ${item['quantity']} × "
                    "${item['price']}₴",
                style: const TextStyle(color: Colors.black87, fontSize: 14),
              ),
            );
          }),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: onRepeat,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Замовити ще раз',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
